// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:watchhub/screens/user/notification_screen.dart';
import 'package:watchhub/screens/user/profile_screen.dart';

// ================= USER SCREENS IMPORTS =================
import 'package:watchhub/screens/users/brand_detail_screen.dart';
import 'package:watchhub/screens/users/brand_list_screen.dart';
import 'package:watchhub/screens/users/cart_screen.dart';
import 'package:watchhub/screens/users/category_screen.dart';
import 'package:watchhub/screens/users/checkout_screen.dart';
import 'package:watchhub/screens/users/edit_profile_screen.dart';
import 'package:watchhub/screens/users/home_screen.dart';
import 'package:watchhub/screens/users/new_arrivals_screen.dart'; // Name adjusted according to your file
import 'package:watchhub/screens/users/notification_screen.dart';
import 'package:watchhub/screens/users/best_seller_screen.dart';
import 'package:watchhub/screens/users/order_history_screen.dart';
import 'package:watchhub/screens/users/order_success_screen.dart';
import 'package:watchhub/screens/users/payment_method_screen.dart';
import 'package:watchhub/screens/users/product_detail_screen.dart'; // Name adjusted according to your file
import 'package:watchhub/screens/users/profile_screen.dart';
import 'package:watchhub/screens/users/search_screen.dart';
import 'package:watchhub/screens/users/settings_screen.dart';
import 'package:watchhub/screens/users/shipping_address_screen.dart';
import 'package:watchhub/screens/users/support_chat_screen.dart';
import 'package:watchhub/screens/users/wishlist_screen.dart';

// ================= AUTH SCREENS IMPORTS =================
import 'screens/auth/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/auth/forgot_password_screen.dart';
import 'screens/auth/onboarding_screen.dart';

// ================= ADMIN SCREENS IMPORTS =================
import 'screens/admin/admin_dashboard_screen.dart';
import 'screens/admin/admin_product_list_screen.dart';
import 'screens/admin/admin_add_product_screen.dart';
import 'screens/admin/admin_orders_screen.dart';
import 'screens/admin/admin_users_screen.dart';
import 'screens/admin/admin_analytics_screen.dart';
import 'screens/admin/admin_edit_product_screen.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    // Auth Flow
    '/splash': (c) => const SplashScreen(),
    '/onboarding': (c) => const OnboardingScreen(),
    '/login': (c) => const LoginScreen(),
    '/signup': (c) => const SignupScreen(),
    '/forgot': (c) => const ForgotPasswordScreen(),

    // User Flow
    '/home': (c) => const HomeScreen(),
    '/product_detail': (c) =>
        const ProductDetailScreen(), // class Name update check karleiyye ga agar screen par ProductDetailsScreen rakha hai to
    '/cart': (c) => const CartScreen(),
    '/checkout': (c) => const CheckoutScreen(),
    '/brands': (c) => const BrandListScreen(),
    '/brand_detail': (c) =>
        const BrandDetailScreen(), // class Name update check karleiyye ga agar screen par BrandDetailsScreen rakha hai to
    '/shipping': (c) => const ShippingAddressScreen(),
    '/payment': (c) => const PaymentMethodScreen(),
    '/order_success': (c) => const OrderSuccessScreen(),
    '/profile': (c) => const ProfileScreen(),
    '/wishlist': (c) => const WishlistScreen(),
    '/edit_profile': (c) => const EditProfileScreen(),
    '/category': (c) => const CategoryScreen(),
    '/new_arrivals': (c) =>
        const NewArrivalsScreen(), // File name ke mutabiq update kiya
    '/settings': (c) => const SettingsScreen(),
    '/support': (c) => const SupportChatScreen(),
    '/order_history': (c) => const OrderHistoryScreen(),
    '/search': (c) => const SearchScreen(),
    '/notifications': (c) => const NotificationScreen(),

    // Admin Flow
    '/admin_dashboard': (c) => const AdminDashboardScreen(),
    '/admin_products': (c) => const AdminProductListScreen(),
    '/admin_add_product': (c) => const AdminAddProductScreen(),
    '/admin_edit_product': (c) => const AdminEditProductScreen(),
    '/admin_orders': (c) => const AdminOrdersScreen(),
    '/admin_users': (c) => const AdminUsersScreen(),
    '/admin_analytics': (c) => const AdminAnalyticsScreen(),
    '/admin_reviews': (c) =>
        const AdminAnalyticsScreen(), // Placeholder linked as your choice
  };
}
