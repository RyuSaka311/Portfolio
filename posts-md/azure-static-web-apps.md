---
title: Azure Static Web Apps でポートフォリオを公開する最短手順
date: 2026-03-03
category: Azure
slug: azure-static-web-apps
description: GitHub連携からデプロイ確認までを短手順で整理。
---
Azure Static Web Apps は、静的サイト公開の初手として扱いやすいサービスです。最短で公開する流れをまとめます。

## 1. リポジトリ準備
公開対象のHTML/CSSをGitHubへpushします。公開ブランチは `main` に揃えると運用がシンプルです。

## 2. Azureリソース作成
Azure PortalでStatic Web Appsを作成し、GitHub認証でリポジトリとブランチを選択します。

## 3. デプロイ確認
初回デプロイ成功後、発行URLで表示確認します。以後は `main` へのpushで自動反映されます。
