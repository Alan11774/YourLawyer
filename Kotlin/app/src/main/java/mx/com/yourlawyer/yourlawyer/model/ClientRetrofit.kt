package mx.com.yourlawyer.yourlawyer.model

import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object ClientRetrofit {
    private const val BASE_URL = "https://private-56712-yourlawyer1.apiary-mock.com/"

    val instance: LawyersApi by lazy {
        Retrofit.Builder()
            .baseUrl(BASE_URL)
            .addConverterFactory(GsonConverterFactory.create())
            .build()
            .create(LawyersApi::class.java)
    }
}