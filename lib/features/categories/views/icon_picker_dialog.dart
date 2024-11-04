import 'package:flutter/material.dart';
import '../../../core/utils/design_utils.dart';

class IconPickerDialog extends StatelessWidget {
  const IconPickerDialog({super.key});

  String _getIconName(IconData icon) {
    // Map of IconData to readable names
    final iconNames = {
      Icons.language: 'Language',
      Icons.public: 'Public',
      Icons.social_distance: 'Social',
      Icons.share: 'Share',
      Icons.web: 'Web',
      Icons.web_asset: 'Web Asset',
      Icons.rss_feed: 'RSS Feed',
      Icons.chat: 'Chat',
      
      // Finance & Shopping
      Icons.account_balance: 'Bank',
      Icons.credit_card: 'Card',
      Icons.shopping_bag: 'Shopping',
      Icons.shopping_cart: 'Cart',
      Icons.store: 'Store',
      Icons.payment: 'Payment',
      Icons.receipt: 'Receipt',
      Icons.attach_money: 'Money',
      
      // Communication
      Icons.email: 'Email',
      Icons.message: 'Message',
      Icons.chat_bubble: 'Chat',
      Icons.phone: 'Phone',
      Icons.contacts: 'Contacts',
      Icons.contact_mail: 'Mail',
      Icons.forum: 'Forum',
      Icons.call: 'Call',
      
      // Work & Education
      Icons.work: 'Work',
      Icons.business: 'Business',
      Icons.school: 'School',
      Icons.cases: 'Cases',
      Icons.badge: 'Badge',
      Icons.corporate_fare: 'Corporate',
      Icons.domain: 'Domain',
      Icons.apartment: 'Apartment',
      
      // Technology
      Icons.computer: 'Computer',
      Icons.laptop: 'Laptop',
      Icons.phone_android: 'Mobile',
      Icons.tablet: 'Tablet',
      Icons.devices: 'Devices',
      Icons.router: 'Router',
      Icons.wifi: 'WiFi',
      Icons.bluetooth: 'Bluetooth',
      
      // Security
      Icons.lock: 'Lock',
      Icons.security: 'Security',
      Icons.vpn_key: 'Key',
      Icons.shield: 'Shield',
      Icons.verified_user: 'Verified',
      Icons.gpp_good: 'Protected',
      Icons.password: 'Password',
      Icons.key: 'Key',
      
      // Entertainment
      Icons.games: 'Games',
      Icons.sports_esports: 'Gaming',
      Icons.movie: 'Movie',
      Icons.music_note: 'Music',
      Icons.tv: 'TV',
      Icons.videogame_asset: 'Game',
      Icons.headphones: 'Audio',
      Icons.casino: 'Casino',
      
      // Travel & Places
      Icons.flight: 'Flight',
      Icons.hotel: 'Hotel',
      Icons.restaurant: 'Food',
      Icons.local_cafe: 'Cafe',
      Icons.car_rental: 'Car',
      Icons.train: 'Train',
      Icons.directions_bus: 'Bus',
      Icons.home: 'Home',
      
      // Health & Lifestyle
      Icons.health_and_safety: 'Health',
      Icons.fitness_center: 'Fitness',
      Icons.spa: 'Spa',
      Icons.medical_services: 'Medical',
      Icons.sports: 'Sports',
      Icons.self_improvement: 'Lifestyle',
      
      // Cloud & Storage
      Icons.cloud: 'Cloud',
      Icons.storage: 'Storage',
      Icons.backup: 'Backup',
      Icons.folder: 'Folder',
      Icons.drive_folder_upload: 'Upload',
      Icons.cloud_upload: 'Upload',
      Icons.save: 'Save',
      
      // Misc
      Icons.star: 'Star',
      Icons.favorite: 'Favorite',
      Icons.bookmark: 'Bookmark',
      Icons.label: 'Label',
      Icons.category: 'Category',
      Icons.tag: 'Tag',
      Icons.extension: 'Extension',
      Icons.settings: 'Settings',
    };

    return iconNames[icon] ?? 'Icon';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: const Text('Choose Icon'),
      content: SizedBox(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.6, // Make dialog scrollable
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 16,  // Increased spacing for name
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,  // Adjusted for name text
          ),
          itemCount: DesignUtils.commonIcons.length,
          itemBuilder: (context, index) {
            final icon = DesignUtils.commonIcons[index];
            final name = _getIconName(icon);
            
            return InkWell(
              onTap: () {
                Navigator.of(context).pop(icon);
              },
              borderRadius: BorderRadius.circular(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 32,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    name,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
} 