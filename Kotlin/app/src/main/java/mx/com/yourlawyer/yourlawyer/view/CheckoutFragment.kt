package mx.com.yourlawyer.yourlawyer.view

import alertDialog
import android.R
import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.AdapterView
import android.widget.ArrayAdapter
import androidx.lifecycle.ViewModelProvider

import com.stripe.android.PaymentConfiguration
import com.stripe.android.Stripe
import com.stripe.android.model.PaymentMethodCreateParams
import com.stripe.android.paymentsheet.PaymentSheet
import com.stripe.android.paymentsheet.PaymentSheetResult
import loadImage
import message
import mx.com.yourlawyer.yourlawyer.controller.UserViewModel
import mx.com.yourlawyer.yourlawyer.databinding.FragmentCheckoutBinding
import mx.com.yourlawyer.yourlawyer.utils.Constants.appName
import mx.com.yourlawyer.yourlawyer.utils.Constants.credit_card_gif
import mx.com.yourlawyer.yourlawyer.utils.Constants.customerID
import mx.com.yourlawyer.yourlawyer.utils.Constants.ephemeralKeySecret
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeClientSecret
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeKey
import mx.com.yourlawyer.yourlawyer.utils.Constants.stripeKeySecret

class CheckoutFragment : Fragment() {

    private var _binding: FragmentCheckoutBinding? = null
    private val binding get() = _binding!!

    private val userViewModel by lazy {
        ViewModelProvider(requireActivity())[UserViewModel::class.java] }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentCheckoutBinding.inflate(inflater, container, false)
        setupUI()
        //stripeDefault()
        return binding.root
    }

    private fun setupUI() {
        loadImage(
            credit_card_gif,
            binding.creditCardImageView,
            binding.root.context
        )
        userViewModel.lawyerProfile.observe(viewLifecycleOwner){ lawyerProfile ->
            binding.serviceCostLabel.text = "Total a pagar: $ ${lawyerProfile.hourlyRate.toString()} MXN"
            binding.lawyerNameLabel.text = "Contratando a: ${lawyerProfile.name}"
            binding.serviceDescriptionLabel.text = "Especialista en: ${lawyerProfile.description}"
            binding.serviceDetailsLabel.text = "El abogado brindará asesoramiento en ${lawyerProfile.description} " +
                    "teniendo habilidades en: ${lawyerProfile.skills}}"

        }
        binding.cancelButton.setOnClickListener {
            requireActivity().supportFragmentManager.popBackStack()
        }
        binding.checkoutButton.setOnClickListener {
            requireActivity().supportFragmentManager.beginTransaction()
                .replace(mx.com.yourlawyer.yourlawyer.R.id.fragment_container, StripeCheckoutFragment())
                .addToBackStack(null)
                .commit()
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }

//    private fun stripeDefault() {
//        // Inicializar PaymentConfiguration
//        PaymentConfiguration.init(requireContext(), stripeKey)
//
//        // Configurar PaymentSheet
//        val paymentSheet = PaymentSheet(this, ::onPaymentSheetResult)
//
//        // Configurar PaymentSheet para un cliente
//        val paymentIntentClientSecret = stripeClientSecret
//        paymentSheet.presentWithPaymentIntent(
//            paymentIntentClientSecret,
//            PaymentSheet.Configuration(
//                merchantDisplayName = appName,
//                customer = PaymentSheet.CustomerConfiguration(
//                    id = customerID,
//                    ephemeralKeySecret = ephemeralKeySecret
//                ),
//                googlePay = PaymentSheet.GooglePayConfiguration(
//                    environment = PaymentSheet.GooglePayConfiguration.Environment.Test,
//                    countryCode = "US"
//                )
//            )
//        )
//    }
    // Manejar el resultado
//    private fun onPaymentSheetResult(paymentResult: PaymentSheetResult) {
//        when (paymentResult) {
//            is PaymentSheetResult.Completed -> {
//                alertDialog(
//                    binding.root.context,
//                    "Pago exitoso",
//                    "Gracias por tu compra")
//            }
//            is PaymentSheetResult.Canceled -> {
//                alertDialog(
//                    binding.root.context,
//                    getString(mx.com.yourlawyer.yourlawyer.R.string.pago_cancelado),
//                    getString(mx.com.yourlawyer.yourlawyer.R.string.tu_pago_ha_sido_cancelado)
//                )
//            }
//            is PaymentSheetResult.Failed -> {
//                message( "Error: ${paymentResult.error.localizedMessage?:"Error desconocido"}")
//            }
//        }
//    }

}

