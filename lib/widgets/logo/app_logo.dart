// lib/widgets/logo/app_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({Key? key, this.size = 100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      '''
<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <defs>
    <linearGradient id="bgGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#2979ff;stop-opacity:1" />
      <stop offset="100%" style="stop-color:#448aff;stop-opacity:1" />
    </linearGradient>
    <linearGradient id="nebulaGradient" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" style="stop-color:#b388ff;stop-opacity:0.8" />
      <stop offset="100%" style="stop-color:#82b1ff;stop-opacity:0.6" />
    </linearGradient>
  </defs>
  
  <!-- 背景圆 -->
  <circle cx="50" cy="50" r="45" fill="url(#bgGradient)"/>
  
  <!-- 数据可视化元素 -->
  <path d="M30 70 L40 55 L50 65 L60 45 L70 60" 
        stroke="#ffffff" 
        stroke-width="3" 
        fill="none" 
        stroke-linecap="round"/>
  
  <!-- 星云效果 -->
  <path d="M25 35 C35 30, 45 40, 75 35 C85 33, 75 50, 65 45 C55 40, 45 50, 35 45 C25 40, 15 40, 25 35Z" 
        fill="url(#nebulaGradient)" 
        opacity="0.7"/>
  
  <!-- 中心星星 -->
  <path d="M 50 40 L 52.9 48.5 L 61.8 48.5 L 54.5 53.5 L 57.4 62 L 50 57 L 42.6 62 L 45.5 53.5 L 38.2 48.5 L 47.1 48.5 Z" 
        fill="#ffffff" 
        opacity="0.9"/>
  
  <!-- 装饰星星 -->
  <circle cx="30" cy="30" r="1.2" fill="#ffffff" opacity="0.9"/>
  <circle cx="70" cy="40" r="1.4" fill="#ffffff" opacity="0.9"/>
  <circle cx="45" cy="25" r="1.0" fill="#ffffff" opacity="0.9"/>
  <circle cx="60" cy="30" r="1.2" fill="#ffffff" opacity="0.9"/>
  <circle cx="75" cy="25" r="1.1" fill="#ffffff" opacity="0.9"/>
  
  <!-- BI文字 -->
  <text x="50" y="58" 
        text-anchor="middle" 
        fill="#ffffff" 
        font-family="Arial, sans-serif" 
        font-weight="bold" 
        font-size="24"
        opacity="0.95">BI</text>
</svg>
      ''',
      width: size,
      height: size,
    );
  }
}