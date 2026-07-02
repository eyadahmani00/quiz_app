# 🎓 Quiz Éducatif

Une application Flutter de quiz interactif pour tester et améliorer vos connaissances sur différents thèmes tech.

## ✨ Fonctionnalités

- 🎨 **8 thèmes disponibles** : Flutter, IoT, Cloud Computing, Big Data, SOA, Machine Learning, Data Science, Web
- 📊 **3 niveaux de difficulté** : Facile, Moyen, Difficile
- ⏱️ **Quiz chronométré** avec 10 questions par session
- 📈 **Résultats détaillés** avec score en pourcentage et feedback personnalisé
- 🎯 Interface simple et intuitive

## 📱 Aperçu

L'application propose une sélection de thème par une interface en grille colorée, suivie d'un choix de difficulté, puis d'une série de questions à choix multiples avec un système de progression et de chronomètre.

## 🚀 Installation

```bash
git clone https://github.com/eyadahmani00/quiz_app.git
cd quiz_app
flutter pub get
flutter run
```

## 🛠️ Technologies

- **Flutter** & **Dart**
- Questions et données stockées en JSON (`assets/questions.json`)

## 📂 Structure du projet
lib/
├── models/         # Modèles de données (Question)
├── pages/          # Écrans (Home, Sélection niveau, Quiz, Résultats)
├── services/        # Logique métier (QuizService)
└── main.dart


## 👤 Auteur

Développé par [eyadahmani00](https://github.com/eyadahmani00)
