package mx.com.yourlawyer.yourlawyer.model
import com.google.gson.annotations.SerializedName

data class LawyersResponseSerialized(
    @SerializedName("lawyers") val lawyers: List<LawyersDto>
)

data class LawyersDto (
    @SerializedName("name") var name: String? = null,

    @SerializedName("description") var subcatedescriptiongory: String? = null,

    @SerializedName("imageURL") var imageUrl: String? = null,

    @SerializedName("projectsWorkedOn") var projectsWorkedOn: Int? = null,

    @SerializedName("ratingVal") var ratingVal: Double? = null,

    @SerializedName("numberOfHirings") var numberOfHirings: Int? = null,

    @SerializedName("profileViews") var profileViews: Int? = null,

    @SerializedName("userDescription") var userDescription: String? = null,

    @SerializedName("skills") var skills: List<String>? = null,

    @SerializedName("hourlyRate") var hourlyRate: Double? = null,


    )