package mx.com.yourlawyer.yourlawyer.view

import alertDialog
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.lifecycle.ViewModelProvider
import com.stripe.android.PaymentConfiguration
import com.stripe.android.paymentsheet.PaymentSheet
import com.stripe.android.paymentsheet.PaymentSheetResult
import message
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.controller.UserViewModel
import mx.com.yourlawyer.yourlawyer.databinding.FragmentCheckoutBinding
import mx.com.yourlawyer.yourlawyer.databinding.FragmentStripeCheckoutBinding
import mx.com.yourlawyer.yourlawyer.utils.Constants.appName
import mx.com.yourlawyer.yourlawyer.utils.Constants.customerID
import mx.com.yourlawyer.yourlawyer.utils.Constants.ephemeralKeySecret
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeClientSecret
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeKey


class StripeCheckoutFragment : Fragment() {

    private var _binding: FragmentStripeCheckoutBinding? = null
    private val binding get() = _binding!!

    private val userViewModel by lazy {
        ViewModelProvider(requireActivity())[UserViewModel::class.java] }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentStripeCheckoutBinding.inflate(inflater, container, false)
        stripeDefault()
        return binding.root
    }

    private fun stripeDefault() {
        // Inicializar PaymentConfiguration
        PaymentConfiguration.init(requireContext(), stripeKey)

        // Configurar PaymentSheet
        val paymentSheet = PaymentSheet(this, ::onPaymentSheetResult)

        // Configurar PaymentSheet para un cliente
        val paymentIntentClientSecret = stripeClientSecret
        paymentSheet.presentWithPaymentIntent(
            paymentIntentClientSecret,
            PaymentSheet.Configuration(
                merchantDisplayName = appName,
                customer = PaymentSheet.CustomerConfiguration(
                    id = customerID,
                    ephemeralKeySecret = ephemeralKeySecret
                ),
                googlePay = PaymentSheet.GooglePayConfiguration(
                    environment = PaymentSheet.GooglePayConfiguration.Environment.Test,
                    countryCode = "US"
                )
            )
        )
    }
    // Manejar el resultado
    private fun onPaymentSheetResult(paymentResult: PaymentSheetResult) {
        when (paymentResult) {
            is PaymentSheetResult.Completed -> {
                alertDialog(
                    binding.root.context,
                    "Pago exitoso",
                    "Gracias por tu compra")
                requireActivity().supportFragmentManager.beginTransaction()
                    .replace(R.id.fragment_container, DetailLawyerFragment())
                    .addToBackStack(null)
                    .commit()
            }

            is PaymentSheetResult.Canceled -> {
                alertDialog(
                    binding.root.context,
                    getString(mx.com.yourlawyer.yourlawyer.R.string.pago_cancelado),
                    getString(mx.com.yourlawyer.yourlawyer.R.string.tu_pago_ha_sido_cancelado)
                )
                requireActivity().supportFragmentManager.popBackStack()
            }
            is PaymentSheetResult.Failed -> {
                message( "Error: ${paymentResult.error.localizedMessage?:"Error desconocido"}")
            }
        }
    }
}



//private fun stripeSetup(){
//    PaymentConfiguration.init(
//        binding.root.context,
//        stripeKey // Reemplaza con tu Publishable Key
//    )
//
//    stripe = Stripe(binding.root.context, PaymentConfiguration.getInstance(binding.root.context).publishableKey)
//
//
//
//    binding.btnPay.setOnClickListener {
//        // Get card details from the CardInputWidget
//        val card = binding.cardInputWidget.paymentMethodCreateParams?.card
//        if (card != null) {
//            handlePayment(card)
//        } else {
//            message( "Introduce una tarjeta válida")
//        }
//    }
//}
//private fun handlePayment(card: PaymentMethodCreateParams.Card?) {
//    val paymentMethodCreateParams = card?.let {
//        PaymentMethodCreateParams.create(
//            it, null
//        )
//        message( "Tarjeta válida: ")
//    }
//
//
//}