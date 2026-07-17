const { onRequest } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const axios = require("axios");
const crypto = require("crypto");

admin.initializeApp();

/**
 * 1. INITIALIZE PAYMENT FUNCTION
 * Called by your Flutter App to get an access code
 */
exports.initializePayment = onRequest({ secrets: ["PAYSTACK_SECRET_KEY"] }, async (req, res) => {
  try {
    // Flutter will send these in the body
    const { email, amount } = req.body; 

    if (!email || !amount) {
      return res.status(400).json({ error: "Missing email or amount" });
    }

    // Paystack expects amount in Kobo/Cents (e.g., 1000 means 10.00 GHS/NGN)
    const paystackResponse = await axios.post(
      "https://api.paystack.co/transaction/initialize",
      {
        email: email,
        amount: amount,
        // Optional: you can pass custom data to track things in the webhook
        metadata: { 
          userId: req.body.userId || "anonymous" 
        }
      },
      {
        headers: {
          Authorization: `Bearer ${process.env.PAYSTACK_SECRET_KEY}`,
          "Content-Type": "application/json",
        },
      }
    );

    // Send the access_code and authorization_url back to Flutter
    return res.status(200).json(paystackResponse.data.data);
  } catch (error) {
    console.error("Initialization Error: ", error.response?.data || error.message);
    return res.status(500).json({ error: "Failed to initialize transaction" });
  }
});


/**
 * 2. PAYSTACK WEBHOOK FUNCTION
 * Configured on the Paystack Dashboard.
 */
exports.paystackWebhook = onRequest({ secrets: ["PAYSTACK_SECRET_KEY"] }, async (req, res) => {
  // Validate signature to prove it came from Paystack
  const hash = crypto
    .createHmac("sha512", process.env.PAYSTACK_SECRET_KEY)
    .update(JSON.stringify(req.body))
    .digest("hex");

  if (hash !== req.headers["x-paystack-signature"]) {
    console.error("Unauthorized request signature mismatch!");
    return res.status(401).send("Unauthorized");
  }

  // Paystack expects a rapid 200 OK response, do not block it
  res.sendStatus(200);

  const event = req.body;

  // Process only successful charges
  if (event.event === "charge.success") {
    const transactionData = event.data;
    const reference = transactionData.reference;
    const email = transactionData.customer.email;
    const metadata = transactionData.metadata;

    console.log(`Payment successful for reference: ${reference}`);

    // Update your Firestore Database securely here
    await admin.firestore().collection("orders").doc(reference).set({
      status: "paid",
      amount: transactionData.amount / 100, // convert back from subunit
      email: email,
      userId: metadata.userId,
      paidAt: new Date(transactionData.paid_at),
    }, { merge: true });
  }
});