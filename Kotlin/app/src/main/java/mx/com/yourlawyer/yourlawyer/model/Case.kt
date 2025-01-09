package mx.com.yourlawyer.yourlawyer.model

data class Case(
    val caseId: String,
    val imageURL: String,
    val title: String,
    val description: String,
    val category: String,
    val postedBy: String,
    val postedDate: String,
    val budget: String,
    val location: String,
    val status: String,
    val details: CaseDetails
)
data class CaseDetails(
    val tags: List<String>,
    val requirements: List<String>,
    val urgency: String
)
data class CasesResponse(
    val cases: List<Case>
)