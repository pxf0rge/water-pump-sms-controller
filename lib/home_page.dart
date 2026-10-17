import 'package:flutter/material.dart';
import 'package:another_telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_app/data_model.dart';
import 'package:sms_app/theme/app_theme.dart';
import 'package:sms_app/utils.dart';
import 'package:sms_app/widgets/pump_status_card.dart';
import 'package:sms_app/widgets/sensor_metric_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final Telephony telephony = Telephony.instance;

  Data recivedData = Data(
    temprature: "0",
    volage: "0",
    power: "0",
    height: "0",
  );

  bool isPumpOn = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        if (value.getStringList("oldData") != null) {
          List<String> data = value.getStringList("oldData")!;
          recivedData = Data(
            temprature: data[0],
            volage: data[1],
            power: data[2],
            height: data[3],
          );
        }
        if (value.getString("phoneNumber") != null) {
          _controller.text = value.getString("phoneNumber")!;
        }
        if (value.getBool("pumpStatus") != null) {
          isPumpOn = value.getBool("pumpStatus")!;
        }
      });
    });

    requestPermission(permission: Permission.sms, telephonyInstance: telephony);

    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) {
        _processMessage(message);
      },
      listenInBackground: false,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool checkPhoneNumber(String phone) {
    if (phone.substring(0, 3) == "+98") {
      if (phone.split("")[3] != "0") {
        if (phone.substring(3).length == 10) {
          if (int.tryParse(phone.substring(3)) != null) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void _processMessage(SmsMessage sms) {
    debugPrint("Message came");
    if (sms.body != null) {
      debugPrint("Message not null");
      List<String> data = sms.body!.trim().split("\n");
      if (data.length >= 4) {
        debugPrint("Message valid");
        setState(() {
          recivedData = Data(
            temprature: data[0],
            volage: data[1],
            power: data[2],
            height: data[3],
          );
        });
        SharedPreferences.getInstance().then((prefs) {
          prefs.setStringList("oldData", data);
        });
      }
    }
  }

  Future<void> _togglePump() async {
    if (checkPhoneNumber(_controller.text)) {
      sendSMS(_controller.text, isPumpOn ? "P0" : "P1");
    } else {
      _showErrorDialog();
      return;
    }
    setState(() {
      isPumpOn = !isPumpOn;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("pumpStatus", isPumpOn);
  }

  void _refreshData() {
    if (checkPhoneNumber(_controller.text)) {
      sendSMS(_controller.text, "R");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.sync_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 10),
              const Text('درخواست بروزرسانی ارسال شد'),
            ],
          ),
        ),
      );
    } else {
      _showErrorDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: AppTheme.screenGradient,
        child: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    PumpStatusCard(isPumpOn: isPumpOn),
                    const SizedBox(height: 20),
                    _buildPhoneSection(),
                    const SizedBox(height: 24),
                    _buildSectionTitle('داده‌های سنسور', Icons.sensors_rounded),
                    const SizedBox(height: 14),
                    _buildSensorGrid(),
                    const SizedBox(height: 28),
                    _buildActionButtons(),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.primary],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.settings_remote_rounded,
              color: AppColors.background,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'GSM Controller',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'کنترل از راه دور پمپ آب',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: AppTheme.cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('شماره دستگاه', Icons.phone_android_rounded),
          const SizedBox(height: 14),
          TextField(
            onChanged: (value) async {
              final SharedPreferences prefs =
                  await SharedPreferences.getInstance();
              prefs.setString("phoneNumber", _controller.text);
            },
            controller: _controller,
            keyboardType: TextInputType.phone,
            textDirection: TextDirection.ltr,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
            decoration: const InputDecoration(
              hintText: '+989123456789',
              prefixIcon: Icon(
                Icons.sim_card_rounded,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'فرمت: +98 بدون صفر اول — مثال: +989121234567',
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.85),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SensorMetricCard(
                icon: Icons.thermostat_rounded,
                label: 'دما',
                value: recivedData.temprature,
                unit: '°C',
                accent: AppColors.temperature,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SensorMetricCard(
                icon: Icons.bolt_rounded,
                label: 'ولتاژ',
                value: recivedData.volage,
                unit: 'V',
                accent: AppColors.voltage,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: SensorMetricCard(
                icon: Icons.power_settings_new_rounded,
                label: 'توان',
                value: recivedData.power,
                unit: 'W',
                accent: AppColors.power,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SensorMetricCard(
                icon: Icons.straighten_rounded,
                label: 'ارتفاع',
                value: recivedData.height,
                unit: 'cm',
                accent: AppColors.height,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        _GradientActionButton(
          onPressed: _togglePump,
          icon: isPumpOn ? Icons.power_settings_new : Icons.play_arrow_rounded,
          label: isPumpOn ? 'خاموش کردن پمپ' : 'روشن کردن پمپ',
          gradient: isPumpOn
              ? const [Color(0xFFEF4444), Color(0xFFDC2626)]
              : const [AppColors.primaryDark, AppColors.primary],
          glowColor: isPumpOn ? AppColors.danger : AppColors.primary,
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 54,
          child: OutlinedButton.icon(
            onPressed: _refreshData,
            icon: const Icon(Icons.refresh_rounded, size: 22),
            label: const Text(
              'بروزرسانی داده‌ها',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textPrimary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> _showErrorDialog() {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.danger.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.error_outline_rounded,
              color: AppColors.danger,
            ),
          ),
          title: const Text('شماره نامعتبر'),
          content: const Text(
            'لطفا شماره تلفن را به درستی بدون 0 و با +98 وارد کنید.',
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: AppColors.textPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('متوجه شدم'),
            ),
          ],
        );
      },
    );
  }
}

class _GradientActionButton extends StatelessWidget {
  const _GradientActionButton({
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.gradient,
    required this.glowColor,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final String label;
  final List<Color> gradient;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          height: 58,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.35),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 10),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
