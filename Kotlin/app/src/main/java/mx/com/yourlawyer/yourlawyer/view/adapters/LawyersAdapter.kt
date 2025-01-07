import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.databinding.ItemLawyerBinding
import mx.com.yourlawyer.yourlawyer.model.Lawyer

class LawyersAdapter(private var lawyers: List<Lawyer>) :
    RecyclerView.Adapter<LawyersAdapter.LawyerViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): LawyerViewHolder {
        val binding = ItemLawyerBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return LawyerViewHolder(binding)
    }

    override fun onBindViewHolder(holder: LawyerViewHolder, position: Int) {
        val lawyer = lawyers[position]
        holder.bind(lawyer)
    }

    override fun getItemCount(): Int = lawyers.size

    fun updateData(newLawyers: List<Lawyer>) {
        lawyers = newLawyers
        notifyDataSetChanged()
    }

    class LawyerViewHolder(private val binding: ItemLawyerBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(lawyer: Lawyer) {
            binding.titleLabel.text = lawyer.name
            binding.subtitleLabel.text = lawyer.description
            binding.priceLabel.text = lawyer.hourlyRate.toString()
            Glide.with(binding.root.context)
                .load(lawyer.imageURL)
                .placeholder(R.drawable.person_resource)
                .into(binding.profileImageView)
        }
    }
}