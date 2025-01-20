package mx.com.yourlawyer.yourlawyer.controller

import android.os.Build
import androidx.annotation.RequiresApi
import mx.com.yourlawyer.yourlawyer.utils.Constants.clientSecretURL
import mx.com.yourlawyer.yourlawyer.utils.Constants.ephemeralURL
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeKeySecret
import okhttp3.*
import okhttp3.MediaType.Companion.toMediaType
import java.io.IOException
import java.util.Base64

val JSON: MediaType = "application/json; charset=utf-8".toMediaType()
val client = OkHttpClient()

fun performPostRequest(
    urlString: String,
    headers: Map<String, String>,
    bodyParameters: Map<String, String>,
    completion: (Result<String>) -> Unit
) {
    val formBodyBuilder = FormBody.Builder()
    for ((key, value) in bodyParameters) {
        formBodyBuilder.add(key, value)
    }
    val formBody = formBodyBuilder.build()

    val requestBuilder = Request.Builder().url(urlString).post(formBody)
    for ((key, value) in headers) {
        requestBuilder.addHeader(key, value)
    }
    val request = requestBuilder.build()

    client.newCall(request).enqueue(object : Callback {
        override fun onFailure(call: Call, e: IOException) {
            completion(Result.failure(e))
        }

        override fun onResponse(call: Call, response: Response) {
            if (!response.isSuccessful) {
                val statusCode = response.code
                val error = IOException("Request failed with status code: $statusCode")
                completion(Result.failure(error))
                return
            }

            val responseData = response.body?.string() ?: ""
            completion(Result.success(responseData))
        }
    })
}

@RequiresApi(Build.VERSION_CODES.O)
fun createEphemeralKey(forCustomerID: String, completion: (Result<String>) -> Unit) {
    val headers = mapOf(
        "Content-Type" to "application/x-www-form-urlencoded",
        "Stripe-Version" to "2022-11-15",
        "Authorization" to "Basic ${Base64.getEncoder().encodeToString(stripeKeySecret.toByteArray(Charsets.UTF_8))}"
    )
    val body = mapOf("customer" to forCustomerID)

    performPostRequest(ephemeralURL, headers, body, completion)
}

@RequiresApi(Build.VERSION_CODES.O)
fun createPaymentIntent(amount: String, currency: String, completion: (Result<String>) -> Unit) {
    val headers = mapOf(
        "Content-Type" to "application/x-www-form-urlencoded",
        "Authorization" to "Basic ${Base64.getEncoder().encodeToString(stripeKeySecret.toByteArray(Charsets.UTF_8))}"
    )
    val body = mapOf(
        "amount" to amount,
        "currency" to currency,
        "automatic_payment_methods[enabled]" to "true"
    )

    performPostRequest(clientSecretURL, headers, body, completion)
}