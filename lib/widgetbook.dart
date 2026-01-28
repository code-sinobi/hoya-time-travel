import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:hoya_app/core/theme/era_theme.dart';
import 'package:hoya_app/core/widgets/mythic_button.dart';
import 'package:hoya_app/core/widgets/mythic_card.dart';

void main() {
  runApp(const HoyaWidgetbook());
}

class HoyaWidgetbook extends StatelessWidget {
  const HoyaWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Mythic Core',
          children: [
            WidgetbookComponent(
              name: 'MythicButton',
              useCases: [
                WidgetbookUseCase(
                  name: 'Primary',
                  builder: (context) => Center(
                    child: MythicButton(
                      label: 'Primary Action',
                      onTap: () {},
                      style: MythicButtonStyle.primary,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Secondary',
                  builder: (context) => Center(
                    child: MythicButton(
                      label: 'Secondary Action',
                      onTap: () {},
                      style: MythicButtonStyle.secondary,
                    ),
                  ),
                ),
                WidgetbookUseCase(
                  name: 'Danger',
                  builder: (context) => Center(
                    child: MythicButton(
                      label: 'Danger Zone',
                      onTap: () {},
                      style: MythicButtonStyle.danger,
                    ),
                  ),
                ),
              ],
            ),
            WidgetbookComponent(
              name: 'MythicCard',
              useCases: [
                WidgetbookUseCase(
                  name: 'Default',
                  builder: (context) => const Padding(
                    padding: EdgeInsets.all(24.0),
                    child: MythicCard(
                      child: Text(
                        'This is a Mythic Card with default styling.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Ancient Era',
              data: ThemeData.dark().copyWith(
                extensions: [AncientEraTheme()],
                scaffoldBackgroundColor: MythicColors.voidBackground,
              ),
            ),
            // Assuming EraTheme uses extensions, we might just pass a basic ThemeData with extensions.
            WidgetbookTheme(
              name: 'Dark Base',
              data: ThemeData.dark().copyWith(
                extensions: [AncientEraTheme()],
                scaffoldBackgroundColor: MythicColors.voidBackground,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
