import 'package:find_the_words/config/sound/cubit/sound_cubit.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/settings/presentation/widgets/settings_row_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SoundSettingsItem extends StatelessWidget {
  const SoundSettingsItem({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SoundCubit, bool>(
      builder: (context, soundEnabled) {
        return SettingsRowItem(
          name: context.translate.settingsItemSound,
          onTap: () => context.read<SoundCubit>().toggleSound(!soundEnabled),
          iconWidget: SizedBox(
            width: 40,
            height: 32,
            child: FittedBox(
              fit: BoxFit.fill,
              child: Switch(
                value: soundEnabled,
                onChanged: (value) =>
                    context.read<SoundCubit>().toggleSound(value),
              ),
            ),
          ),
        );
      },
    );
  }
}
