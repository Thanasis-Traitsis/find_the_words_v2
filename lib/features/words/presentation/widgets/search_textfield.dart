import 'package:find_the_words/config/theme/custom_text_type.dart';
import 'package:find_the_words/core/constants/constants.dart';
import 'package:find_the_words/core/utils/text_extensions.dart';
import 'package:find_the_words/features/words/presentation/total_words_bloc/total_words_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchTextfield extends StatefulWidget {
  const SearchTextfield({super.key});

  @override
  State<SearchTextfield> createState() => _SearchTextfieldState();
}

class _SearchTextfieldState extends State<SearchTextfield> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _searchController,
      onChanged: (query) {
        context.read<TotalWordsBloc>().add(SearchWordsEvent(query));
      },
      style: TextStyle(fontSize: CustomTextType.regularBody.fontSize),
      decoration: InputDecoration(
        hintText: '${context.translate.searchPlaceholder} ...',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacingL,
          vertical: AppSpacing.spacingS,
        ),
        border: OutlineInputBorder(borderRadius: AppBorders.bigBorderRadius),
      ),
    );
  }
}
