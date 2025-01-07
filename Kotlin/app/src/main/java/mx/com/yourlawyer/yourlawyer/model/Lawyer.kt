package mx.com.yourlawyer.yourlawyer.model

data class LawyersResponse(
    val lawyers: List<Lawyer>
    )
data class Lawyer(
    val name: String,
    val description: String,
    val imageURL: String?,
    val projectsWorkedOn : Int,
    val ratingVal : Double,
    val numberOfHirings: Int,
    val profileViews: Int,
    val userDescription: String,
    val skills: List<String>,
    val hourlyRate: Double
)