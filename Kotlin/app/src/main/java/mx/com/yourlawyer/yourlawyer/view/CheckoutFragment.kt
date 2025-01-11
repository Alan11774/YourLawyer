package mx.com.yourlawyer.yourlawyer.view

import android.os.Bundle
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import mx.com.yourlawyer.yourlawyer.R

import android.widget.AdapterView
import android.widget.ArrayAdapter
import android.widget.Spinner
import android.widget.Toast
import loadImage
import message
import mx.com.yourlawyer.yourlawyer.databinding.FragmentCheckoutBinding
import mx.com.yourlawyer.yourlawyer.utils.Constants.credit_card_gif

class CheckoutFragment : Fragment() {

    private var _binding: FragmentCheckoutBinding? = null
    private val binding get() = _binding!!

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentCheckoutBinding.inflate(inflater, container, false)
        setupUI()
        return binding.root
    }

    private fun setupUI() {
        loadImage(
            credit_card_gif,
            binding.creditCardImageView,
            binding.root.context,
            R.drawable.legal
        )

        // Configuración del Spinner de métodos de pago
        val paymentMethods = arrayOf("Tarjeta de Crédito", "PayPal", "Transferencia Bancaria")
        val adapter = ArrayAdapter(
            requireContext(),
            android.R.layout.simple_spinner_item,
            paymentMethods
        )
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        binding.paymentMethodSpinner.adapter = adapter

        binding.paymentMethodSpinner.onItemSelectedListener = object : AdapterView.OnItemSelectedListener {
            override fun onItemSelected(parent: AdapterView<*>?, view: View?, position: Int, id: Long) {
                val selectedMethod = paymentMethods[position]
                Toast.makeText(requireContext(), "Método seleccionado: $selectedMethod", Toast.LENGTH_SHORT).show()
            }

            override fun onNothingSelected(parent: AdapterView<*>?) {
            }
        }

        // Botón para confirmar contratación
        binding.confirmButton.setOnClickListener {
            message("Contratación confirmada")
        }

        // Botón para cancelar
        binding.cancelButton.setOnClickListener {
            message( "Contratación cancelada")
            requireActivity().onBackPressedDispatcher.onBackPressed()
        }
    }

    override fun onDestroyView() {
        super.onDestroyView()
        _binding = null
    }
}