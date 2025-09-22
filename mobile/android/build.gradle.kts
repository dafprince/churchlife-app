// build.gradle.kts (racine du projet)
plugins {
    id("com.android.application") version "8.7.3" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Redirection du dossier build global pour le projet Flutter
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// Tâche clean
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
