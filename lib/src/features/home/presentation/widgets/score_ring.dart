import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';

class ScoreRing extends StatelessWidget {
  const ScoreRing({super.key});

  static const Color _scoreColor = Color(0xFFF4C63D);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 92.r,
      height: 92.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 92.r,
            height: 92.r,
            child: CircularProgressIndicator(
              value: 0.82,
              strokeWidth: 10.r,
              strokeCap: StrokeCap.round,
              backgroundColor: const Color(0xFFEDEDED),
              valueColor: const AlwaysStoppedAnimation<Color>(_scoreColor),
            ),
          ),
          Text(
            '82%',
            style: context.textTheme.titleLarge?.copyWith(
              color: _scoreColor,
              fontSize: 23.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
