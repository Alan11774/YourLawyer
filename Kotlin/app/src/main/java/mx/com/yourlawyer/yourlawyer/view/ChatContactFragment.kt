package mx.com.yourlawyer.yourlawyer.view

import android.content.Context
import android.os.Bundle
import android.util.AttributeSet
import androidx.fragment.app.Fragment
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import mx.com.yourlawyer.yourlawyer.R

import android.widget.*
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.Query
import loadImage
import message
import mx.com.yourlawyer.yourlawyer.controller.UserViewModel
import mx.com.yourlawyer.yourlawyer.databinding.FragmentChatContactBinding
import mx.com.yourlawyer.yourlawyer.databinding.FragmentDetailLawyerBinding
import mx.com.yourlawyer.yourlawyer.model.Lawyer
import mx.com.yourlawyer.yourlawyer.model.Message
import mx.com.yourlawyer.yourlawyer.view.adapters.MessageAdapter

class ChatContactFragment : Fragment() {

    private var _binding: FragmentChatContactBinding? = null
    private val binding get() = _binding!!

    private val db = FirebaseFirestore.getInstance()
    private val auth = FirebaseAuth.getInstance()

    private lateinit var messageAdapter: MessageAdapter
    private val messages = mutableListOf<Message>()

    private lateinit var lawyer: Lawyer


    private val userViewModel by lazy {
        ViewModelProvider(requireActivity())[UserViewModel::class.java] }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View {
        _binding = FragmentChatContactBinding.inflate(inflater, container, false)
        userViewModel.lawyerProfile.observe(viewLifecycleOwner){lawyerProfile ->
            lawyer = lawyerProfile
        }
        setupUI()
        loadMessages()
        return binding.root
    }
    private fun returnAction(){

        requireActivity().onBackPressedDispatcher.onBackPressed()
    }

    private fun setupUI() {
        // Tabla mensajes
        binding.messagesRecyclerView.layoutManager = LinearLayoutManager(binding.root.context)
        messageAdapter = MessageAdapter(messages)
        binding.messagesRecyclerView.adapter = messageAdapter


        //  datos del abogado
        userViewModel.lawyerProfile.observe(viewLifecycleOwner){ lawyerProfile ->
            val imageURL = lawyerProfile.imageURL
            if (imageURL != null) {
                loadImage(imageURL,
                    binding.lawyerImageView,
                    binding.root.context)
            }
            binding.nameLabel.text = lawyerProfile.name

        }
// Botones

        binding.sendButton.setOnClickListener { sendMessage() }
        binding.returnButton.setOnClickListener { returnAction() }
    }


    private fun sendMessage() {
        val text = binding.messageInput.text.toString().trim()
        if (text.isEmpty()) return

        val currentUserEmail = auth.currentUser?.email ?: return
        val messageData = mapOf(
            "text" to text,
            "timestamp" to System.currentTimeMillis(),
            "senderId" to currentUserEmail,
            "receiverId" to lawyer.id
        )

        db.collection("messages")
            .document(currentUserEmail)
            .collection(lawyer.id.toString())
            .add(messageData)
            .addOnSuccessListener {
                binding.messageInput.text.clear()
            }
            .addOnFailureListener { e ->
                message( "Error al enviar mensaje: ${e.message}")
            }

    }

    private fun loadMessages() {
        val currentUserEmail = auth.currentUser?.email ?: return

        userViewModel.lawyerProfile.observe(viewLifecycleOwner){lawyerProfile  ->
            db.collection("messages")
                .document(currentUserEmail)
                .collection(lawyerProfile.id.toString())
                .orderBy("timestamp", Query.Direction.ASCENDING)
                .addSnapshotListener { snapshot, error ->
                    if (error != null) {
                        message( "Error al cargar mensajes: ${error.message}")
                        return@addSnapshotListener
                    }

                    messages.clear()
                    for (doc in snapshot!!.documents) {
                        val text = doc.getString("text") ?: continue
                        val senderId = doc.getString("senderId") ?: continue
                        val isCurrentUser = senderId == currentUserEmail
                        messages.add(Message(text, isCurrentUser))
                    }
                    messageAdapter.notifyDataSetChanged()
                    binding.messagesRecyclerView.scrollToPosition(messages.size - 1)
                }

        }

    }
}