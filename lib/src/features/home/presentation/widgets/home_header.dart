import 'package:mobilepos/src/imports/core_imports.dart';
import 'package:mobilepos/src/imports/packages_imports.dart';
import 'package:mobilepos/src/features/home/presentation/providers/home_provider.dart';
import 'header_icon_button.dart';

class HomeHeader extends ConsumerStatefulWidget {
  const HomeHeader({
    super.key,
    required this.title,
    required this.selectedTab,
    required this.onNewSale,
    required this.onMenuPressed,
  });

  final String title;
  final HomeTab selectedTab;
  final VoidCallback onNewSale;
  final VoidCallback onMenuPressed;

  @override
  ConsumerState<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends ConsumerState<HomeHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(homeControllerProvider).itemSearchQuery,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colors;
    final state = ref.watch(homeControllerProvider);
    final controller = ref.read(homeControllerProvider.notifier);
    final isItemsTab = widget.selectedTab == HomeTab.items;
    final showSearch = isItemsTab && state.isItemSearchVisible;
    if (_searchController.text != state.itemSearchQuery) {
      _searchController.value = TextEditingValue(
        text: state.itemSearchQuery,
        selection:
            TextSelection.collapsed(offset: state.itemSearchQuery.length),
      );
    }

    return Container(
      padding: EdgeInsets.only(
        left: 10.w,
        right: 10.w,
        top: MediaQuery.paddingOf(context).top + 12.h,
        bottom: 10.h,
      ),
      color: colorScheme.surface,
      child: Column(
        children: [
          if (showSearch)
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _searchController,
                    hint: 'Search items',
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    prefixIcon: const Icon(FlutterRemix.search_line),
                    onChanged: controller.setItemSearchQuery,
                  ),
                ),
                SizedBox(width: 8.w),
                HeaderIconButton(
                  icon: FlutterRemix.close_line,
                  onPressed: () {
                    _searchController.clear();
                    controller.hideItemSearch();
                  },
                ),
              ],
            )
          else
            Row(
              children: [
                HeaderIconButton(
                  isMenu: true,
                  icon: FlutterRemix.menu_2_line,
                  onPressed: widget.onMenuPressed,
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Text(
                    widget.title,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (isItemsTab) ...[
                  HeaderIconButton(
                    icon: state.isItemsGridView
                        ? FlutterRemix.list_unordered
                        : FlutterRemix.layout_grid_fill,
                    onPressed: controller.toggleItemsLayout,
                  ),
                  SizedBox(width: 10.w),
                ],
                HeaderIconButton(
                  icon: FlutterRemix.search_line,
                  onPressed: () {
                    if (!isItemsTab) {
                      controller.selectTab(HomeTab.items);
                    }
                    controller.showItemSearch();
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
