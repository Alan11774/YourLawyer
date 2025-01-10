//import android.view.LayoutInflater
//import android.view.ViewGroup
//import androidx.recyclerview.widget.RecyclerView
//import com.bumptech.glide.Glide
//import mx.com.yourlawyer.yourlawyer.R
//import mx.com.yourlawyer.yourlawyer.databinding.ItemLawyerBinding
//import mx.com.yourlawyer.yourlawyer.model.Lawyer
//
//class LawyersAdapter(private var lawyers: List<Lawyer>) :
//    RecyclerView.Adapter<LawyersAdapter.LawyerViewHolder>() {
//
//    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): LawyerViewHolder {
//        val binding = ItemLawyerBinding.inflate(
//            LayoutInflater.from(parent.context),
//            parent,
//            false
//        )
//        return LawyerViewHolder(binding)
//    }
//
//    override fun onBindViewHolder(holder: LawyerViewHolder, position: Int) {
//        val lawyer = lawyers[position]
//        holder.bind(lawyer)
//    }
//
//    override fun getItemCount(): Int = lawyers.size
//
//    fun updateData(newLawyers: List<Lawyer>) {
//        lawyers = newLawyers
//        notifyDataSetChanged()
//    }
//
//    class LawyerViewHolder(private val binding: ItemLawyerBinding) :
//        RecyclerView.ViewHolder(binding.root) {
//
//        fun bind(lawyer: Lawyer) {
//            binding.titleLabel.text = lawyer.name
//            binding.subtitleLabel.text = lawyer.description
//            binding.priceLabel.text = lawyer.hourlyRate.toString()
//            Glide.with(binding.root.context)
//                .load(lawyer.imageURL)
//                .placeholder(R.drawable.person_resource)
//                .into(binding.profileImageView)
//        }
//    }
//}

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.databinding.ItemCaseBinding
import mx.com.yourlawyer.yourlawyer.databinding.ItemLawyerBinding
import mx.com.yourlawyer.yourlawyer.model.Case
import mx.com.yourlawyer.yourlawyer.model.Lawyer

sealed class UnifiedItem {
    data class LawyerItem(val lawyer: Lawyer) : UnifiedItem()
    data class CaseItem(val case: Case) : UnifiedItem()
}

class UnifiedAdapter(
    private var items: List<UnifiedItem>,
    private val onCaseClick: (Case) -> Unit,
    private val onLawyerClick: (Lawyer) -> Unit
) : RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    companion object {
        private const val VIEW_TYPE_LAWYER = 1
        private const val VIEW_TYPE_CASE = 2
    }

    override fun getItemViewType(position: Int): Int {
        return when (items[position]) {
            is UnifiedItem.LawyerItem -> VIEW_TYPE_LAWYER
            is UnifiedItem.CaseItem -> VIEW_TYPE_CASE
            else -> {
                throw IllegalArgumentException("Invalid view type")
            }
        }
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        return when (viewType) {
            VIEW_TYPE_LAWYER -> {
                val binding = ItemLawyerBinding.inflate(
                    LayoutInflater.from(parent.context),
                    parent,
                    false
                )
                LawyerViewHolder(binding)
            }
            VIEW_TYPE_CASE -> {
                val binding = ItemCaseBinding.inflate(
                    LayoutInflater.from(parent.context),
                    parent,
                    false
                )
                CaseViewHolder(binding)
            }
            else -> throw IllegalArgumentException("Invalid view type")
        }
    }

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder) {
            is LawyerViewHolder -> {
                val lawyer = (items[position] as UnifiedItem.LawyerItem).lawyer
                holder.bind(lawyer, onLawyerClick)
            }
            is CaseViewHolder -> {
                val case = (items[position] as UnifiedItem.CaseItem).case
                holder.bind(case, onCaseClick)
            }
        }
    }

    override fun getItemCount(): Int = items.size

    fun updateData(newItems: List<UnifiedItem>) {
        items = newItems
        notifyDataSetChanged()
    }

    class LawyerViewHolder(private val binding: ItemLawyerBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(lawyer: Lawyer, onLawyerClick: (Lawyer) -> Unit) {
            binding.titleLabel.text = lawyer.name
            binding.subtitleLabel.text = lawyer.description
            binding.priceLabel.text = lawyer.hourlyRate.toString()
            Glide.with(binding.root.context)
                .load(lawyer.imageURL)
                .placeholder(R.drawable.person_resource)
                .into(binding.profileImageView)

            binding.root.setOnClickListener {
                onLawyerClick(lawyer)
            }
        }
    }

    class CaseViewHolder(private val binding: ItemCaseBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(case: Case, onCaseClick: (Case) -> Unit) {
            binding.descriptionLabel.text = case.title
            binding.budgetLabel.text = case.budget.toString()
            Glide.with(binding.root.context)
                .load(case.imageURL)
                .transform(RoundedCorners(16))
                .placeholder(R.drawable.resize)
                .into(binding.profileImageView)

            binding.root.setOnClickListener {
                onCaseClick(case)
            }
        }
    }
}