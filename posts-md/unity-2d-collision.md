---
title: Unity 2D で当たり判定を安定させる設計メモ
date: 2026-03-03
category: Unity
slug: unity-2d-collision
description: すり抜けを減らすための最低限の設計ポイント。
---
2Dアクションでは、移動処理と衝突処理の責務が混ざると不具合が増えます。安定させる基本を整理します。

## 1. Update と FixedUpdate を分離
入力はUpdate、物理演算はFixedUpdateに分けます。入力値を保持し、FixedUpdateでRigidbody2Dへ適用します。

## 2. レイヤー衝突マトリクスを先に決める
プレイヤー、敵、地形、攻撃判定の衝突組み合わせを最初に固定し、不要な衝突を切ります。

## 3. すり抜け対策
高速移動体には Continuous を検討し、必要に応じてRaycastを補助的に使います。
