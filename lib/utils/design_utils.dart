import 'package:flutter/material.dart';

class DesignUtils {
  static const List<IconData> commonIcons = [
    // Web & Social
    Icons.language, Icons.public, Icons.social_distance, Icons.share,
    Icons.web, Icons.web_asset, Icons.rss_feed, Icons.chat,
    
    // Finance & Shopping
    Icons.account_balance, Icons.credit_card, Icons.shopping_bag,
    Icons.shopping_cart, Icons.store, Icons.payment, Icons.receipt,
    Icons.attach_money,
    
    // Communication
    Icons.email, Icons.message, Icons.chat_bubble, Icons.phone,
    Icons.contacts, Icons.contact_mail, Icons.forum, Icons.call,
    
    // Work & Education
    Icons.work, Icons.business, Icons.school, Icons.cases,
    Icons.badge, Icons.corporate_fare, Icons.domain, Icons.apartment,
    
    // Technology
    Icons.computer, Icons.laptop, Icons.phone_android, Icons.tablet,
    Icons.devices, Icons.router, Icons.wifi, Icons.bluetooth,
    
    // Security
    Icons.lock, Icons.security, Icons.vpn_key, Icons.shield,
    Icons.verified_user, Icons.gpp_good, Icons.password, Icons.key,
    
    // Entertainment
    Icons.games, Icons.sports_esports, Icons.movie, Icons.music_note,
    Icons.tv, Icons.videogame_asset, Icons.headphones, Icons.casino,
    
    // Travel & Places
    Icons.flight, Icons.hotel, Icons.restaurant, Icons.local_cafe,
    Icons.car_rental, Icons.train, Icons.directions_bus, Icons.home,
    
    // Health & Lifestyle
    Icons.health_and_safety, Icons.fitness_center, Icons.spa,
    Icons.medical_services, Icons.sports, Icons.self_improvement,
    
    // Cloud & Storage
    Icons.cloud, Icons.storage, Icons.backup, Icons.folder,
    Icons.drive_folder_upload, Icons.cloud_upload, Icons.save,
    
    // Misc
    Icons.star, Icons.favorite, Icons.bookmark, Icons.label,
    Icons.category, Icons.tag, Icons.extension, Icons.settings,
  ];

  static const List<MaterialColor> categoryColors = [
    Colors.red, Colors.pink, Colors.purple, Colors.deepPurple,
    Colors.indigo, Colors.blue, Colors.lightBlue, Colors.cyan,
    Colors.teal, Colors.green, Colors.lightGreen, Colors.lime,
    Colors.yellow, Colors.amber, Colors.orange, Colors.deepOrange,
    Colors.brown, Colors.blueGrey, Colors.grey,
  ];

  static final List<List<Color>> colorShades = [
    [Colors.red, Colors.red[300]!, Colors.redAccent[200]!],
    [Colors.pink, Colors.pink[300]!, Colors.pinkAccent[200]!],
    [Colors.purple, Colors.purple[300]!, Colors.purpleAccent[200]!],
    [Colors.deepPurple, Colors.deepPurple[300]!, Colors.deepPurpleAccent[200]!],
    [Colors.indigo, Colors.indigo[300]!, Colors.indigoAccent[200]!],
    [Colors.blue, Colors.blue[300]!, Colors.blueAccent[200]!],
    [Colors.lightBlue, Colors.lightBlue[300]!, Colors.lightBlueAccent[200]!],
    [Colors.cyan, Colors.cyan[300]!, Colors.cyanAccent[200]!],
    [Colors.teal, Colors.teal[300]!, Colors.tealAccent[200]!],
    [Colors.green, Colors.green[300]!, Colors.greenAccent[200]!],
    [Colors.lightGreen, Colors.lightGreen[300]!, Colors.lightGreenAccent[200]!],
    [Colors.lime, Colors.lime[300]!, Colors.limeAccent[200]!],
    [Colors.yellow, Colors.yellow[300]!, Colors.yellowAccent[200]!],
    [Colors.amber, Colors.amber[300]!, Colors.amberAccent[200]!],
    [Colors.orange, Colors.orange[300]!, Colors.orangeAccent[200]!],
    [Colors.deepOrange, Colors.deepOrange[300]!, Colors.deepOrangeAccent[200]!],
    [Colors.brown, Colors.brown[300]!, Colors.brown[200]!],
    [Colors.blueGrey, Colors.blueGrey[300]!, Colors.blueGrey[200]!],
    [Colors.grey, Colors.grey[300]!, Colors.grey[200]!],
  ];

  // Minimum window dimensions
  static const double minWindowWidth = 400.0;
  static const double minWindowHeight = 600.0;
  
  // Standard padding and spacing
  static const double standardPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
} 