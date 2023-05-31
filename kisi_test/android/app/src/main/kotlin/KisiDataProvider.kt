import android.content.Context
import android.nfc.cardemulation.HostApduService
import android.os.Build
import android.os.Bundle
import androidx.annotation.RequiresApi
import de.kisi.android.st2u.Login
import de.kisi.android.st2u.Scram3
import io.reactivex.rxjava3.core.Maybe
import io.reactivex.rxjava3.disposables.Disposable
import io.reactivex.rxjava3.observers.DisposableSingleObserver

@RequiresApi(Build.VERSION_CODES.KITKAT)
class KisiDataProvider(private val context: Context, private val id: Int, private val secret: String, private val phoneKey: String, private val certificate: String,) : HostApduService() {

    private lateinit var offlineMode: Scram3

    private var disposable: Disposable? = null

    override fun onCreate() {
        super.onCreate()

        offlineMode = Scram3.with(
            clientId = 1004,
            //context = applicationContext,
            context = context,
            loginFetcher = { organizationId: Int? ->
                Maybe.just(
                    // ATTENTION - This is an example Login object that you will need to replace
                    // with a correct one obtained from Kisi's API. Read our integration docs
                    // mentioned above to get an idea of how to do that.
                    Login(
                        id = id,
                        secret = secret,
                        phoneKey = phoneKey,
                        onlineCertificate = certificate
                    )
                )
            },
            onUnlockComplete = { }
        )
    }

    override fun processCommandApdu(commandApdu: ByteArray, extras: Bundle?): ByteArray? {
        disposable = offlineMode
            .handle(commandApdu)
            .subscribeWith(
                object : DisposableSingleObserver<ByteArray>() {
                    override fun onSuccess(t: ByteArray) {
                        sendResponseApdu(t)
                    }

                    override fun onError(e: Throwable) {
                        sendResponseApdu(null)
                    }
                }
            )

        return null
    }

    override fun onDeactivated(reason: Int) {
        disposable?.dispose()
        disposable = null
    }
}