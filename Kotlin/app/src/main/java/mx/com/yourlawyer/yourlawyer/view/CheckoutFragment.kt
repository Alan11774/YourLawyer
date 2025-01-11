package mx.com.yourlawyer.yourlawyer.view

import android.R
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter

import com.stripe.android.PaymentConfiguration
import com.stripe.android.Stripe
import com.stripe.android.model.PaymentMethodCreateParams
import com.stripe.android.paymentsheet.PaymentSheet
import com.stripe.android.paymentsheet.PaymentSheetResult
import loadImage
import message
import mx.com.yourlawyer.yourlawyer.databinding.FragmentCheckoutBinding
import mx.com.yourlawyer.yourlawyer.utils.Constants.credit_card_gif
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeClientSecret
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeKey
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeKeySecret

class CheckoutFragment : Fragment() {
    private lateinit var stripe: Stripe

    private var _binding: FragmentCheckoutBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentCheckoutBinding.inflate(inflater, container, false)
//        setupUI()
//        stripeSetup()
        stripeDefault()
        return binding.root
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
//    private fun handlePayment(card: PaymentMethodCreateParams.Card?) {
//        val paymentMethodCreateParams = card?.let {
//            PaymentMethodCreateParams.create(
//                it, null
//            )
//            message( "Tarjeta válida: ")
//        }
//
//        // Aquí necesitas enviar los datos al backend para procesar el pago
//
//    }
//    private fun setupUI() {
//        loadImage(
//            credit_card_gif,
//            binding.creditCardImageView,
//            binding.root.context
//        )
//
//        // Configuración del Spinner de métodos de pago
//        val paymentMethods = arrayOf("Tarjeta de Crédito", "PayPal", "Transferencia Bancaria")
//        val adapter = ArrayAdapter(
//            requireContext(),
//            R.layout.simple_spinner_item,
//            paymentMethods
//        )
//        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
//        binding.paymentMethodSpinner.adapter = adapter
//
//        binding.paymentMethodSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
//            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
//                val selectedMethod = paymentMethods[position]
//                message( "Método seleccionado: $selectedMethod")
//            }
//
//            override fun onNothingSelected(parent: AdapterView<*>?) {
//            }
//        }
//
//        // Botón para confirmar contratación
//        binding.confirmButton.setOnClickListener {
//            message("Contratación confirmada")
//        }
//
//        // Botón para cancelar
//        binding.cancelButton.setOnClickListener {
//            message( "Contratación cancelada")
//            requireActivity().onBackPressedDispatcher.onBackPressed()
//        }
//    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
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
                merchantDisplayName = "YourLawyer",
                customer = PaymentSheet.CustomerConfiguration(
                    id = "cus_RZ6a59X4B957OP",
                    ephemeralKeySecret = "ek_test_YWNjdF8xUWZ1NTBGYkhBSzlNQ2pWLDJGVDhLN2MwSTdKaEJocnV6VGlGN21qZEJBTThIcjA_00IuFMrTYo"
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
                message( "Pago completado")
            }
            is PaymentSheetResult.Canceled -> {
                message( "Pago cancelado")
            }
            is PaymentSheetResult.Failed -> {
                message( "Error: ${paymentResult.error.localizedMessage}")
            }
        }
    }
}