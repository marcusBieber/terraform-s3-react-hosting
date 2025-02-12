# Deployment einer React-Website mit Terraform und S3

Dieses Projekt nutzt Terraform, um eine React-App zu bauen und auf AWS S3 als statische Website zu hosten.

Der Build-Prozess findet in Terraform statt.

## 🚀 Anforderungen

- [Terraform](https://developer.hashicorp.com/terraform/downloads) installiert
- [AWS CLI](https://aws.amazon.com/de/cli/) konfiguriert (`aws configure`)
- Git installiert

## 👅 Repository klonen

```sh
git clone https://github.com/marcusBieber/terraform-s3-react-hosting.git
cd terraform-s3-react-hosting
```

## 🏠 Terraform initialisieren

Führe den folgenden Befehl aus, um die Terraform-Provider zu laden:

```sh
terraform init
```

## 🚀 Infrastruktur bereitstellen

Starte den Build-Prozess der React-App und erstelle die AWS-Ressourcen:

```sh
terraform apply -auto-approve
```

Nach erfolgreichem Deployment wird die URL der Website als Output angezeigt.

## 🚫 Infrastruktur löschen

Falls du die Infrastruktur wieder entfernen möchtest:

```sh
terraform destroy -auto-approve
```

