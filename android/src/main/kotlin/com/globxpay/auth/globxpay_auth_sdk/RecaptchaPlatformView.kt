package com.globxpay.auth.globxpay_auth_sdk

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import android.webkit.JavascriptInterface
import android.webkit.WebView
import android.webkit.WebResourceRequest
import android.webkit.WebViewClient
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

class RecaptchaPlatformView(
    private val context: Context,
    id: Int,
    creationParams: Map<String, Any>?,
    messenger: BinaryMessenger
) : PlatformView {

    private val webView: WebView = WebView(context)
    private val methodChannel: MethodChannel

    init {
        methodChannel = MethodChannel(messenger, "globx_recaptcha_view_$id")
        setupWebView(creationParams)
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun setupWebView(creationParams: Map<String, Any>?) {
        val apiKey = creationParams?.get("apiKey") as? String ?: ""

        webView.settings.apply {
            javaScriptEnabled = true
            domStorageEnabled = true
            loadWithOverviewMode = true
            useWideViewPort = true
            // Allow loading external resources (needed for Google reCAPTCHA script)
            mixedContentMode = android.webkit.WebSettings.MIXED_CONTENT_ALWAYS_ALLOW
            // Enable network access
            blockNetworkLoads = false
            blockNetworkImage = false
            // Enable caching to improve performance
            cacheMode = android.webkit.WebSettings.LOAD_DEFAULT
            // Enable database for DOM storage
            databaseEnabled = true
            // Set user agent to ensure proper compatibility
            userAgentString = userAgentString + " GlobXPay/1.0"
        }

        webView.addJavascriptInterface(RecaptchaJavaScriptInterface(), "RecaptchaHandler")

        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                val url = request?.url?.toString() ?: return false
                android.util.Log.d("RecaptchaWebView", "URL loading: $url")

                // Allow our base URL and Google reCAPTCHA URLs to load in WebView
                if (url.startsWith("https://appassets.androidplatform.net/") ||
                    url.contains("google.com/recaptcha") ||
                    url.contains("gstatic.com") ||
                    url.contains("recaptcha")
                ) {
                    return false // Let WebView handle it
                }

                // Send external URLs to Flutter for opening via url_launcher
                android.util.Log.d("RecaptchaWebView", "Sending URL to Flutter: $url")
                methodChannel.invokeMethod("onOpenUrl", url)
                return true
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: android.graphics.Bitmap?) {
                super.onPageStarted(view, url, favicon)
                android.util.Log.d("RecaptchaWebView", "Page started loading")
                methodChannel.invokeMethod("onPageStarted", null)
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                android.util.Log.d("RecaptchaWebView", "Page finished loading")
                methodChannel.invokeMethod("onPageFinished", null)
            }

            override fun onReceivedError(view: WebView?, request: android.webkit.WebResourceRequest?, error: android.webkit.WebResourceError?) {
                super.onReceivedError(view, request, error)
                android.util.Log.e("RecaptchaWebView", "WebView error: ${error?.description}")
                android.util.Log.e("RecaptchaWebView", "Error code: ${error?.errorCode}")
                android.util.Log.e("RecaptchaWebView", "Failed URL: ${request?.url}")
                android.util.Log.e("RecaptchaWebView", "Is main frame: ${request?.isForMainFrame}")

                // Notify Flutter about the error
                methodChannel.invokeMethod("onError", mapOf(
                    "description" to error?.description.toString(),
                    "errorCode" to error?.errorCode,
                    "url" to request?.url.toString()
                ))
            }

            override fun onReceivedHttpError(view: WebView?, request: android.webkit.WebResourceRequest?, errorResponse: android.webkit.WebResourceResponse?) {
                super.onReceivedHttpError(view, request, errorResponse)
                android.util.Log.e("RecaptchaWebView", "HTTP error: ${errorResponse?.statusCode} for ${request?.url}")
            }

            override fun onReceivedSslError(view: WebView?, handler: android.webkit.SslErrorHandler?, error: android.net.http.SslError?) {
                super.onReceivedSslError(view, handler, error)
                android.util.Log.e("RecaptchaWebView", "SSL error: ${error?.toString()}")
                // DO NOT proceed with SSL errors in production - this is for debugging only
                // handler?.proceed()
            }
        }

        // Add WebChromeClient to capture console logs
        webView.webChromeClient = object : android.webkit.WebChromeClient() {
            override fun onConsoleMessage(consoleMessage: android.webkit.ConsoleMessage?): Boolean {
                android.util.Log.d("RecaptchaConsole", "${consoleMessage?.message()} -- From line ${consoleMessage?.lineNumber()} of ${consoleMessage?.sourceId()}")
                return true
            }
        }

        val htmlContent = """
            <!DOCTYPE html>
            <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <script src="https://www.google.com/recaptcha/api.js?render=$apiKey"></script>
                <style>
                    body {
                        display: flex;
                        justify-content: center;
                        align-items: center;
                        min-height: 100vh;
                        margin: 0;
                        font-family: Arial, sans-serif;
                        background-color: #f5f5f5;
                    }
                    .container {
                        text-align: center;
                        padding: 20px;
                    }
                    .logo {
                        width: 80px;
                        height: 80px;
                        margin: 0 auto 20px;
                    }
                    #status {
                        font-size: 16px;
                        color: #333;
                        margin-top: 20px;
                    }
                    .spinner {
                        border: 3px solid #f3f3f3;
                        border-top: 3px solid #4285f4;
                        border-radius: 50%;
                        width: 40px;
                        height: 40px;
                        animation: spin 1s linear infinite;
                        margin: 20px auto;
                    }
                    @keyframes spin {
                        0% { transform: rotate(0deg); }
                        100% { transform: rotate(360deg); }
                    }
                    .recaptcha-badge {
                        margin-top: 20px;
                        font-size: 12px;
                        color: #999;
                    }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="spinner"></div>
                    <div id="status">Loading reCAPTCHA...</div>
                    <div class="recaptcha-badge">Protected by reCAPTCHA</div>
                </div>
                <script>
                    console.log('🔵 Script started');
                    console.log('🔵 API Key: $apiKey');
                    console.log('🔵 RecaptchaHandler available:', typeof RecaptchaHandler !== 'undefined');

                    // Auto-execute reCAPTCHA when page loads
                    grecaptcha.ready(function() {
                        console.log('✅ grecaptcha.ready() called');
                        document.getElementById('status').textContent = 'Verifying...';

                        grecaptcha.execute('$apiKey', {action: 'submit'})
                            .then(function(token) {
                                console.log('✅ Token received from Google:', token.substring(0, 50) + '...');
                                document.getElementById('status').textContent = 'Verified Successfully!';
                                document.querySelector('.spinner').style.display = 'none';

                                console.log('🔵 Calling RecaptchaHandler.onToken()');
                                try {
                                    RecaptchaHandler.onToken(token);
                                    console.log('✅ RecaptchaHandler.onToken() called successfully');
                                } catch (e) {
                                    console.error('❌ Error calling RecaptchaHandler:', e);
                                }
                            })
                            .catch(function(error) {
                                console.error('❌ reCAPTCHA error:', error);
                                document.getElementById('status').textContent = 'Verification failed. Please try again.';
                                document.querySelector('.spinner').style.display = 'none';
                            });
                    });
                </script>
            </body>
            </html>
        """.trimIndent()

        // Use a proper base URL to allow loading external scripts (required for Google reCAPTCHA)
        webView.loadDataWithBaseURL("https://appassets.androidplatform.net/", htmlContent, "text/html", "UTF-8", null)
    }

    inner class RecaptchaJavaScriptInterface {
        @JavascriptInterface
        fun onToken(token: String) {
            android.util.Log.d("RecaptchaToken", "✅ Token received from JavaScript: ${token.take(50)}...")
            android.util.Log.d("RecaptchaToken", "Invoking Flutter method channel...")
            methodChannel.invokeMethod("onToken", token)
            android.util.Log.d("RecaptchaToken", "Flutter method channel invoked successfully")
        }
    }

    override fun getView(): View {
        return webView
    }

    override fun dispose() {
        webView.destroy()
    }
}
