package mx.com.yourlawyer.yourlawyer.model

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import mx.com.yourlawyer.yourlawyer.controller.UserViewModel
import mx.com.yourlawyer.yourlawyer.databinding.FragmentDetailLawyerBinding
import mx.com.yourlawyer.yourlawyer.databinding.FragmentPostCaseBinding

class PostCaseFragment : Fragment() {
    private var _binding: FragmentPostCaseBinding? = null
    private val binding get() = _binding!!

    private val auth = FirebaseAuth.getInstance()
    private val db = FirebaseFirestore.getInstance()
    private val userViewModel by lazy {
        ViewModelProvider(requireActivity())[UserViewModel::class.java] }



    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {

        _binding = FragmentPostCaseBinding.inflate(inflater, container, false)
        setupUI()

        // Configurar listeners
        applyButton.setOnClickListener {
            proposalLinearLayout.visibility = View.VISIBLE
            Toast.makeText(requireContext(), "Aplicar para el caso", Toast.LENGTH_SHORT).show()
        }

        cancelButton.setOnClickListener {
            proposalLinearLayout.visibility = View.GONE
            Toast.makeText(requireContext(), "Cancelado", Toast.LENGTH_SHORT).show()
        }

        submitApplyButton.setOnClickListener {
            val budget = budgetEditText.text.toString()
            if (budget.isNotEmpty()) {
                finalBudgetProposalTextView.text = "Propuesta de presupuesto: $budget"
                finalBudgetProposalTextView.visibility = View.VISIBLE
                proposalLinearLayout.visibility = View.GONE
                Toast.makeText(requireContext(), "Propuesta enviada", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(requireContext(), "Por favor ingresa un presupuesto", Toast.LENGTH_SHORT).show()
            }
        }

        return view
    }

    private fun setupUI() {

    }
}