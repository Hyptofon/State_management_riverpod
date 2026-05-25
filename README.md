# 🛒 LR11: State Management з Riverpod

Цей проєкт є виконанням лабораторної роботи **LR11: State Management з Riverpod — E-commerce додаток**.

У додатку реалізовано список продуктів, кошик покупок, підрахунок загальної ціни та збереження даних кошика.

🌐 **Live Demo:** [https://state-management-riverpod.web.app](https://state-management-riverpod.web.app)

---

## 🎯 Мета роботи

Створити E-commerce додаток з управлінням станом через `Riverpod`, який включає:

- список продуктів;
- додавання товарів у кошик;
- видалення товарів з кошика;
- підрахунок кількості товарів;
- обчислення загальної ціни;
- збереження кошика після перезапуску додатку.

---

## ✅ Виконані обов'язкові завдання

### 1. Налаштування Riverpod

- Додано залежність `flutter_riverpod`.
- Додаток обгорнуто в `ProviderScope`.
- Для читання стану використовуються `ConsumerWidget`, `ref.watch()` та `ref.read()`.

### 2. Модель Product

Створено модель `Product` з полями:

- `id`
- `name`
- `price`
- `category`
- `image`

Також додано `copyWith()` та базову валідацію даних у конструкторі.

### 3. ProductsProvider

- Створено `productsProvider`.
- Додано 10 mock-продуктів.
- Продукти мають різні категорії та унікальні `id`.

### 4. Products Screen

- Створено екран `ProductsScreen`.
- Продукти відображаються через `ListView.builder`.
- Для кожного товару показано emoji, назву, категорію, ціну та кнопку `Add to Cart`.
- У AppBar додано іконку кошика з badge.

### 5. CartProvider

- Створено `cartProvider` на основі `StateNotifierProvider`.
- Реалізовано методи:
  - `addProduct()`
  - `incrementProduct()`
  - `decrementProduct()`
  - `removeProduct()`
  - `clear()`
- Стан кошика оновлюється імутабельно.

### 6. Додавання в кошик

- Кнопка `Add to Cart` додає товар у кошик.
- Якщо товар уже є в кошику, збільшується його кількість.
- Після додавання показується `SnackBar`.

### 7. Cart Screen

- Створено екран `CartScreen`.
- Відображається список товарів у кошику.
- Є кнопка `Clear`.
- Є empty state `Cart is empty`.
- Для кожного товару доступне видалення.

### 8. Total Price

- Створено `cartTotalProvider`.
- Загальна сума автоматично оновлюється при зміні кошика.
- Ціна форматується у вигляді `$999.99`.

### 9. Видалення з кошика

- Реалізовано видалення товару кнопкою.
- Додано видалення свайпом через `Dismissible`.
- Після видалення оновлюються badge, кількість і total.

### 10. Cart Badge

- Створено `cartCountProvider`.
- Badge показує кількість товарів у кошику.
- Якщо кошик порожній, badge не відображається.

---

## 🌟 Додаткові завдання

У проєкті реалізовано всі додаткові варіанти:

### Варіант A: Категорії продуктів

- Додано `FilterChip`.
- Можна фільтрувати товари за категоріями.

### Варіант B: Quantity в кошику

- Однакові товари не дублюються.
- Для товарів зберігається `quantity`.
- Додано кнопки `+` та `-`.

### Варіант C: Збереження кошика

- Кошик зберігається через `SharedPreferences`.
- Після перезапуску додатку товари залишаються в кошику.

### Варіант D: Пошук продуктів

- Додано поле пошуку.
- Товари фільтруються за назвою.

---

## 📁 Структура проєкту

```text
lib/
├── main.dart
├── constants/
│   ├── app_strings.dart
│   └── app_dimensions.dart
├── models/
│   ├── product.dart
│   ├── cart_item.dart
│   ├── cart_state.dart
│   └── stored_cart_item.dart
├── providers/
│   ├── products_provider.dart
│   └── cart_provider.dart
├── repositories/
│   ├── cart_storage_repository.dart
│   ├── shared_preferences_cart_storage_repository.dart
│   └── cart_storage_exception.dart
├── screens/
│   ├── products_screen.dart
│   └── cart_screen.dart
├── utils/
│   ├── app_snack_bar.dart
│   └── currency_formatter.dart
└── widgets/
    ├── product_card.dart
    ├── cart_item_tile.dart
    ├── cart_badge_button.dart
    ├── checkout_summary.dart
    ├── category_filter_chips.dart
    ├── product_search_field.dart
    ├── empty_cart_view.dart
    └── empty_products_view.dart
```

---

## 🚀 Як запустити

1. Встановити залежності:

```bash
flutter pub get
```

2. Запустити додаток:

```bash
flutter run
```

3. Запустити web-версію:

```bash
flutter run -d chrome
```

4. Перевірити код:

```bash
flutter analyze
flutter test
```

---

## 👤 Автор

| Поле | Деталі |
| :--- | :--- |
| **Студент** | Войтюк Назарій |
| **Група** | КН-311 |
| **Завдання** | LR11 — State Management з Riverpod |
| **Live Demo** | [state-management-riverpod.web.app](https://state-management-riverpod.web.app) |
