import android.net.Uri
import android.os.Bundle
import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.core.net.toUri
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import mx.com.yourlawyer.yourlawyer.R
import mx.com.yourlawyer.yourlawyer.databinding.ItemCaseBinding
import mx.com.yourlawyer.yourlawyer.model.Case
import mx.com.yourlawyer.yourlawyer.model.Profile
import mx.com.yourlawyer.yourlawyer.model.ProfileManager
import mx.com.yourlawyer.yourlawyer.view.DetailCaseFragment
import mx.com.yourlawyer.yourlawyer.view.ProfileFragment


class CasesAdapter(
    private val cases: List<Case>,
    private val onCaseClick: (Case) -> Unit
) :

    RecyclerView.Adapter<CasesAdapter.CaseViewHolder>() {

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): CaseViewHolder {
        val binding = ItemCaseBinding.inflate(
            LayoutInflater.from(parent.context),
            parent,
            false
        )
        return CaseViewHolder(binding)
    }

    override fun onBindViewHolder(holder: CaseViewHolder, position: Int) {
        val case = cases[position]
        holder.bind(case)

        holder.binding.apply {
            budgetLabel.text = case.title
            descriptionLabel.text = case.description
            Glide.with(root.context)
                .load(case.imageURL)
                .transform(RoundedCorners(16))
                .into(profileImageView)
            root.setOnClickListener {
                onCaseClick(case)
            }
        }

    }

    override fun getItemCount(): Int = cases.size

    class CaseViewHolder(val binding: ItemCaseBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(case: Case) {
            binding.descriptionLabel.text = case.title
            binding.budgetLabel.text = case.budget.toString()

            Glide.with(binding.root.context)
                .load(
                    case.imageURL
                ).centerCrop()
                .transform(RoundedCorners(100)) // Ajusta el radio
                .placeholder(R.drawable.resize)
                .into(binding.profileImageView)

        }
    }

//    fun updateData(newCases: List<Case>) {
//        cases = newCases
//        notifyDataSetChanged() // Notifica a RecyclerView que los datos han cambiado
//    }
}