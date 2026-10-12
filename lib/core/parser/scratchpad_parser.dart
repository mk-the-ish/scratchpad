enum EntryType { expense, task }

enum CurrencyType { usd, zig }

enum ExpenseCategory { transit, food, dataAirtime, utilities, general }

class ParsedResult {
  final EntryType type;
  final String rawText;
  
  // Expense fields (nullable if type is task)
  final double? amount;
  final CurrencyType? currency;
  final String? walletHint;
  final ExpenseCategory? category;
  
  // Task fields (nullable if type is expense)
  final String title;
  final bool isTopLever;
  final String? scheduledTime;

  ParsedResult({
    required this.type,
    required this.rawText,
    required this.title,
    this.amount,
    this.currency,
    this.walletHint,
    this.category,
    this.isTopLever = false,
    this.scheduledTime,
  });
}

class ScratchpadParser {
  // Regex patterns
  static final RegExp _usdPattern = RegExp(
    r'(?:^\$|^\s*\$\s*|\busd\s*|\beco\s*|\becocash\s*)(\d+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );
  
  static final RegExp _zigPattern = RegExp(
    r'(?:^zig\s*|\bzig\s*)(\d+(?:\.\d{1,2})?)',
    caseSensitive: false,
  );

  static final RegExp _genericAmountPattern = RegExp(
    r'^(\d+(?:\.\d{1,2})?)\s+',
  );

  static final RegExp _timePattern = RegExp(
    r'\b(\d{1,2}(?::\d{2})?\s*(?:am|pm)?|\bnoon\b|\btonight\b|\bmorning\b)',
    caseSensitive: false,
  );

  static ParsedResult parse(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) {
      return ParsedResult(
        type: EntryType.task,
        rawText: input,
        title: '',
      );
    }

    // 1. Check for Expense Triggers
    final isEco = trimmed.toLowerCase().startsWith('eco');
    final usdMatch = _usdPattern.firstMatch(trimmed);
    final zigMatch = _zigPattern.firstMatch(trimmed);
    final genericMatch = _genericAmountPattern.firstMatch(trimmed);

    if (usdMatch != null || zigMatch != null || (genericMatch != null && _containsExpenseKeywords(trimmed))) {
      return _parseExpense(trimmed, usdMatch, zigMatch, genericMatch, isEco);
    }

    // 2. Default to Task
    return _parseTask(trimmed);
  }

  static bool _containsExpenseKeywords(String text) {
    final keywords = ['combi', 'kombi', 'fare', 'bread', 'pie', 'lunch', 'bundles', 'airtime', 'fuel', 'tokens'];
    return keywords.any((k) => text.toLowerCase().contains(k));
  }

  static ParsedResult _parseExpense(
    String text,
    Match? usdMatch,
    Match? zigMatch,
    Match? genericMatch,
    bool isEco,
  ) {
    double amount = 0.0;
    CurrencyType currency = CurrencyType.usd;
    String wallet = isEco ? 'EcoCash USD' : 'USD Cash';
    String cleanedNote = text;

    if (zigMatch != null) {
      amount = double.tryParse(zigMatch.group(1) ?? '0') ?? 0.0;
      currency = CurrencyType.zig;
      wallet = 'ZiG Account';
      cleanedNote = text.replaceFirst(zigMatch.group(0)!, '').trim();
    } else if (usdMatch != null) {
      amount = double.tryParse(usdMatch.group(1) ?? '0') ?? 0.0;
      currency = CurrencyType.usd;
      cleanedNote = text.replaceFirst(usdMatch.group(0)!, '').trim();
    } else if (genericMatch != null) {
      amount = double.tryParse(genericMatch.group(1) ?? '0') ?? 0.0;
      currency = CurrencyType.usd;
      cleanedNote = text.replaceFirst(genericMatch.group(0)!, '').trim();
    }

    // Infer category based on local colloquialisms
    final category = _categorizeExpense(cleanedNote);

    return ParsedResult(
      type: EntryType.expense,
      rawText: text,
      title: cleanedNote.isEmpty ? 'Expense' : cleanedNote,
      amount: amount,
      currency: currency,
      walletHint: wallet,
      category: category,
    );
  }

  static ExpenseCategory _categorizeExpense(String note) {
    final lower = note.toLowerCase();
    if (lower.contains('combi') || lower.contains('kombi') || lower.contains('fare') || lower.contains('town') || lower.contains('lift')) {
      return ExpenseCategory.transit;
    }
    if (lower.contains('lunch') || lower.contains('bread') || lower.contains('pie') || lower.contains('food') || lower.contains('drinks') || lower.contains('water')) {
      return ExpenseCategory.food;
    }
    if (lower.contains('bundle') || lower.contains('airtime') || lower.contains('netone') || lower.contains('econet')) {
      return ExpenseCategory.dataAirtime;
    }
    if (lower.contains('zesa') || lower.contains('token') || lower.contains('city of harare')) {
      return ExpenseCategory.utilities;
    }
    return ExpenseCategory.general;
  }

  static ParsedResult _parseTask(String text) {
    bool isTopLever = false;
    String cleaned = text;

    // Check for high-priority prefix: '!' or '*'
    if (cleaned.startsWith('!') || cleaned.startsWith('*')) {
      isTopLever = true;
      cleaned = cleaned.substring(1).trim();
    }

    // Extract optional scheduled time
    final timeMatch = _timePattern.firstMatch(cleaned);
    String? scheduledTime;
    if (timeMatch != null) {
      scheduledTime = timeMatch.group(0);
      cleaned = cleaned.replaceFirst(timeMatch.group(0)!, '').trim();
    }

    return ParsedResult(
      type: EntryType.task,
      rawText: text,
      title: cleaned,
      isTopLever: isTopLever,
      scheduledTime: scheduledTime,
    );
  }
}