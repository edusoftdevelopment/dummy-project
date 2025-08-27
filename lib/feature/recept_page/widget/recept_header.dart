part of 'widget.dart';

// --- rest of widgets stay the same (ReceiptHeader, ReceiptBalances, ReceiptFooter, LabelValue) ---
class ReceiptHeader extends ConsumerWidget {
  const ReceiptHeader({
    required this.screenWidth,
    required this.screenHeight,
    required this.list,
    required this.index,
    required this.itemCount,
    required this.totalPages,
    required this.currentPage,
    super.key,
  });
  final double screenWidth;
  final List<TableDataModel> list;
  final double screenHeight;
  final int index;
  final int itemCount;
  final int totalPages;
  final int currentPage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final creditSum = ref.watch(TransactionSumProviders.creditSumProvider('$index'));
    final debitSum = ref.watch(TransactionSumProviders.debitSumProvider('$index'));
    final balanceSum = ref.watch(TransactionSumProviders.balanceSumProvider('$index'));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (currentPage == 1)
          Column(
            children: [
              const Row(
                children: [
                  AutoSizeText(
                    "MAJOR ELECTRICAL'S",
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  Spacer(),
                  AutoSizeText(
                    'Print Date: 17 AUG 2025',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.001),
              const AutoSizeText(
                'Party Payment Recipt Ledger',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              SizedBox(height: screenHeight * 0.001),
              const AutoSizeText(
                'Party: 124 - Cash Party - Sargodha',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ReceiptLedgerTable(
          itemCount: itemCount,
          indexFromOut: index, // Start index
          list: list,
        ),
        SizedBox(height: screenHeight * 0.001),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            AutoSizeText(
              'Total Debit: ${debitSum.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 2),
            ),
            // const Spacer(),
            AutoSizeText(
              'Total Credit: ${creditSum.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 2),
            ),
            // const Spacer(),
            AutoSizeText(
              'Total Balance: ${balanceSum.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 2),
            ),
            // const Spacer(),
          ],
        ),
        SizedBox(height: screenHeight * 0.001),
        AutoSizeText(
          'Page $currentPage/$totalPages',
          style: const TextStyle(fontSize: 2),
        ),
      ],
    );
  }
}
