# Portfolio / Tech Blog

静的HTMLベースの技術ブログです。トップページは `index.html`、記事は `posts/` に配置されます。

## 構成
- `index.html`: ブログトップ
- `style.css`: 共通スタイル
- `posts/`: 公開用記事HTML
- `posts-md/`: 記事のMarkdown原本
- `scripts/build-posts.ps1`: Markdownから記事HTMLを生成
- `favicon.svg`: サイトアイコン
- `robots.txt` / `sitemap.xml`: 公開向け設定

## 記事追加フロー（推奨）
1. `posts-md/` に `.md` を追加
2. 先頭に front matter を記載
3. `scripts/build-posts.ps1` を実行

front matter 例:

```yaml
---
title: 記事タイトル
date: 2026-03-03
category: Azure
slug: sample-post
description: 記事の短い説明
---
```

生成コマンド:

```powershell
./scripts/build-posts.ps1 -BaseUrl "https://your-domain.example"
```

## 公開前チェック
- `index.html` の記事リンクを追加・更新
- `sitemap.xml` のURLを実ドメインに変更
- `robots.txt` のSitemap URLを実ドメインに変更
- OGP (`og:url`) は実ドメイン反映済み

