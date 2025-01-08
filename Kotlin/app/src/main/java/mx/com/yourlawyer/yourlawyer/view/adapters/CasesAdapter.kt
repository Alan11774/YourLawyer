import android.net.Uri
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


class CasesAdapter(private var cases: List<Case>) :


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
    }

    override fun getItemCount(): Int = cases.size

    class CaseViewHolder(private val binding: ItemCaseBinding) :
        RecyclerView.ViewHolder(binding.root) {

        fun bind(case: Case) {
            binding.descriptionLabel.text = case.title
            binding.budgetLabel.text = case.budget.toString()
            Glide.with(binding.root.context)
                .load(
                    R.drawable.resize
                ).centerCrop()
                .transform(RoundedCorners(100)) // Ajusta el radio
                .into(binding.profileImageView)

        }
    }
    fun updateData(newCases: List<Case>) {
        cases = newCases
        notifyDataSetChanged() // Notifica a RecyclerView que los datos han cambiado
    }
}