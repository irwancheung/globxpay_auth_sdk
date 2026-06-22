allprojects {
    repositories {
        google()
        mavenCentral()
        maven("https://jitpack.io") {
            content {
                includeGroup("com.github.florent37")
            }
        }
        maven("https://fpjs.jfrog.io/artifactory/maven") {
            content {
                includeGroup("com.fingerprint.android")
            }
        }
        maven("https://cashshield-sdk.s3.amazonaws.com/release/") {
            content {
                includeGroup("com.shield.android")
                includeGroup("com.shield.android.module")
            }
        }
        maven("https://mobile-sdk.idwise.ai/releases/") {
            content {
                includeGroup("com.idwise")
                includeGroup("com.shield.android")
                includeGroup("com.shield.android.module")
                includeGroup("com.fingerprint.android")
                includeGroup("com.github.florent37")
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
