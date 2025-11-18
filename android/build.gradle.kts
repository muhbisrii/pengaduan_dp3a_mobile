buildscript {
    // Tentukan versi Kotlin (sintaks Kotlin)
    val kotlin_version = "1.9.23"
    
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // Ini adalah dependensi standar Flutter (sintaks Kotlin)
        classpath("com.android.tools.build:gradle:8.4.1")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version")
        
        // --- INI ADALAH BARIS PENTING UNTUK FIREBASE (sintaks Kotlin) ---
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Ini adalah bagian bawah standar (yang Anda paste tadi, tapi versi Kotlin)
val newBuildDir: org.gradle.api.file.Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: org.gradle.api.file.Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}