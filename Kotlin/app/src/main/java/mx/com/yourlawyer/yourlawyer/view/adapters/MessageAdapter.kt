package mx.com.yourlawyer.yourlawyer.view.adapters
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.recyclerview.widget.RecyclerView
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.model.Message

class MessageAdapter(private val messages: List<Message>) :
    RecyclerView.Adapter<MessageAdapter.MessageViewHolder>() {



    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): MessageViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(R.layout.item_message, parent, false)
        return MessageViewHolder(view)
    }


    // *****************************************************************************
    // Logica para saber quien manda y recibe mensajes
    // ****************************************************************************
    override fun onBindViewHolder(holder: MessageViewHolder, position: Int) {
        val message = messages[position]
        if (message.isCurrentUser) {
            holder.messageText.setBackgroundResource(R.drawable.message_background)
            (holder.messageText.layoutParams as ConstraintLayout.LayoutParams).apply {
                startToStart = ConstraintLayout.LayoutParams.UNSET
                endToEnd = ConstraintLayout.LayoutParams.PARENT_ID
            }
        } else {
            holder.messageText.setBackgroundResource(R.drawable.message_received)
            (holder.messageText.layoutParams as ConstraintLayout.LayoutParams).apply {
                endToEnd = ConstraintLayout.LayoutParams.UNSET
                startToStart = ConstraintLayout.LayoutParams.PARENT_ID
            }
        }
        holder.messageText.text = message.text
    }

    override fun getItemCount() = messages.size

    class MessageViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        val messageText: TextView = itemView.findViewById(R.id.messageText)

        fun bind(message: Message) {
            messageText.text = message.text
            messageText.textAlignment = if (message.isCurrentUser) View.TEXT_ALIGNMENT_TEXT_END else View.TEXT_ALIGNMENT_TEXT_START
        }
    }
}