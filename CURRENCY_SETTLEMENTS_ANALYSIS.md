# Анализ схемы взаиморасчетов в разных валютах

**Дата анализа:** 2025-11-20
**Анализируемая система:** IRP (Information Resource Planning)
**Фокус анализа:** Регистры PartnerBalance и механизм работы с мультивалютными взаиморасчетами

---

## Содержание

1. [Обзор архитектуры](#обзор-архитектуры)
2. [Ключевые регистры](#ключевые-регистры)
3. [Механизм работы с валютами](#механизм-работы-с-валютами)
4. [Процесс зачета авансов](#процесс-зачета-авансов)
5. [Проблемные места](#проблемные-места)
6. [Рекомендации](#рекомендации)

---

## Обзор архитектуры

Система взаиморасчетов с партнерами построена на основе четырех основных регистров накопления:

### Архитектура взаиморасчетов

```
┌─────────────────────────────────────────────────────┐
│           ПОСТАВЩИКИ (Vendors)                      │
├─────────────────────────────────────────────────────┤
│ R1020B_AdvancesToVendors      - Авансы поставщикам │
│ R1021B_VendorsTransactions    - Транзакции         │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│           КЛИЕНТЫ (Customers)                       │
├─────────────────────────────────────────────────────┤
│ R2020B_AdvancesFromCustomers  - Авансы от клиентов │
│ R2021B_CustomersTransactions  - Транзакции         │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│           ЗАЧЕТ АВАНСОВ                             │
├─────────────────────────────────────────────────────┤
│ T2010S_OffsetOfAdvances       - Информация о зачете│
└─────────────────────────────────────────────────────┘
```

---

## Ключевые регистры

### 1. R1020B_AdvancesToVendors (Авансы поставщикам)

**Файл:** `/IRP/src/AccumulationRegisters/R1020B_AdvancesToVendors/R1020B_AdvancesToVendors.mdo`

**Измерения:**
- `Company` - Компания
- `Branch` - Подразделение
- **`CurrencyMovementType`** - Тип валютного движения (ключевое поле для мультивалютности)
- **`Currency`** - Валюта учета
- **`TransactionCurrency`** - Валюта транзакции
- `LegalName` - Юридическое лицо контрагента
- `Partner` - Партнер
- `Agreement` - Договор
- `Order` - Заказ
- `Project` - Проект

**Ресурсы:**
- `Amount` - Сумма аванса

**Атрибуты:**
- `VendorsAdvancesClosing` - Ссылка на документ зачета авансов

---

### 2. R1021B_VendorsTransactions (Транзакции поставщиков)

**Файл:** `/IRP/src/AccumulationRegisters/R1021B_VendorsTransactions/R1021B_VendorsTransactions.mdo`

**Измерения:** (аналогично R1020B с добавлением)
- `Basis` - Документ-основание транзакции (Invoice, Return и т.д.)

**Отличия от R1020B:**
- Вместо `Order` используется `Basis` для привязки к документу-основанию
- Хранит задолженности по поставкам

---

### 3. R2020B_AdvancesFromCustomers (Авансы от клиентов)

**Файл:** `/IRP/src/AccumulationRegisters/R2020B_AdvancesFromCustomers/R2020B_AdvancesFromCustomers.mdo`

Структура полностью аналогична R1020B, но для клиентов.

---

### 4. R2021B_CustomersTransactions (Транзакции клиентов)

**Файл:** `/IRP/src/AccumulationRegisters/R2021B_CustomersTransactions/R2021B_CustomersTransactions.mdo`

Структура полностью аналогична R1021B, но для клиентов.

---

### 5. T2010S_OffsetOfAdvances (Зачет авансов)

**Файл:** `/IRP/src/InformationRegisters/T2010S_OffsetOfAdvances/T2010S_OffsetOfAdvances.mdo`

**Тип:** Регистр сведений (подчинен регистратору)

**Ключевые измерения:**
- `Document` - Документ, в котором происходит зачет
- `RecordType` - Тип записи (Receipt/Expense)
- `IsAdvanceRelease` - Признак освобождения аванса
- **`Currency`** - Валюта (⚠️ только одно поле для валюты!)
- `Partner`, `LegalName`, `Agreement` - Идентификаторы партнера
- `TransactionDocument` - Документ транзакции
- `AdvanceOrder` - Заказ аванса
- `TransactionOrder` - Заказ транзакции
- `AdvanceProject` - Проект аванса
- `TransactionProject` - Проект транзакции
- `Key` - Уникальный ключ строки

**Ресурсы:**
- `Amount` - Сумма зачета

---

## Механизм работы с валютами

### Концепция CurrencyMovementType

Система использует концепцию **типов валютных движений** для учета сумм в различных валютах:

```
CurrencyMovementType:
├── SettlementCurrency   - Валюта расчетов (валюта транзакции)
├── LegalCurrency        - Валюта юр.лица
├── RegCurrency          - Валюта регламентированного учета
└── др. настраиваемые типы
```

### Двойной валютный учет

Каждая запись в регистрах балансов содержит **два валютных поля**:

1. **`Currency`** - Целевая валюта для данного типа движения (зависит от CurrencyMovementType)
2. **`TransactionCurrency`** - Исходная валюта документа/транзакции

**Пример:**
```
Документ: Оплата 100 USD
Компания: ООО "Пример" (валюта учета RUB)

Записи в регистр:
┌─────────────────────────┬──────────┬─────────────────────┬────────┐
│ CurrencyMovementType    │ Currency │ TransactionCurrency │ Amount │
├─────────────────────────┼──────────┼─────────────────────┼────────┤
│ SettlementCurrency      │ USD      │ USD                 │ 100    │
│ LegalCurrency           │ RUB      │ USD                 │ 9500   │
└─────────────────────────┴──────────┴─────────────────────┴────────┘
```

### Обработка валют в CurrenciesServer

**Файл:** `/IRP/src/CommonModules/CurrenciesServer/Module.bsl`

**Ключевые функции:**

#### GetPartnerBalanceTables() (строка 1269)
Определяет регистры, участвующие в балансе партнеров:
```bsl
Function GetPartnerBalanceTables()
	PartnerBalanceTables = New Structure();
	PartnerBalanceTables.Insert("R2020B_AdvancesFromCustomers", New ValueTable());
	PartnerBalanceTables.Insert("R2021B_CustomersTransactions", New ValueTable());
	PartnerBalanceTables.Insert("R1020B_AdvancesToVendors", New ValueTable());
	PartnerBalanceTables.Insert("R1021B_VendorsTransactions", New ValueTable());
	Return PartnerBalanceTables;
EndFunction
```

#### UpdatePartnerBalanceTables() (строка 1289)
Обновляет информацию о валютах и суммах в регистрах:
- Получает записи с `CurrencyMovementType = SettlementCurrency`
- Обновляет Currency и Amount в информационных регистрах транзакций (T2015S) и авансов (T2014S)

#### PreparePostingDataTables() (строка 46)
Главная процедура подготовки данных для записи:
1. Проверяет наличие колонок для зачета (`CustomersAdvancesClosing`, `VendorsAdvancesClosing`)
2. Разделяет записи на основные и записи зачета
3. Для записей зачета создает отдельную таблицу валют по договорам
4. Вызывает `_PreparePostingDataTables` дважды: для основных записей и для записей зачета

---

## Процесс зачета авансов

### Документы зачета

**VendorsAdvancesClosing** (`/IRP/src/Documents/VendorsAdvancesClosing/`)
- Зачет авансов поставщикам против задолженности

**CustomersAdvancesClosing** (`/IRP/src/Documents/CustomersAdvancesClosing/`)
- Зачет авансов от клиентов против задолженности

### Модуль OffsetOfAdvancesServer

**Файл:** `/IRP/src/CommonModules/OffsetOfAdvancesServer/Module.bsl`

#### Основная логика: OffsetOfAdvancesAndAging() (строка 2)

**Этапы процесса:**

1. **Инициализация** (строки 4-52)
   - Определение типа документа (Customers/Vendors)
   - Установка параметров регистров и типов

2. **Очистка предыдущих записей** (строка 80)
   ```bsl
   Clear_SelfRecords(Parameters);
   ```

3. **Создание ключей авансов** (строка 102)
   ```bsl
   CreateAdvancesKeys(Parameters, Records_AdvancesKey,
                      Records_OffsetOfAdvances,
                      Table_DocumentAndAdvancesKey);
   ```

4. **Создание ключей транзакций** (строка 123)
   ```bsl
   CreateTransactionsKeys(Parameters, Records_TransactionsKey,
                          Records_OffsetAging,
                          Table_DocumentAndTransactionsKey);
   ```

5. **Зачет по времени** (строки 190-250)
   - Сортировка всех ключей по `PointInTime`
   - Последовательный зачет:
     - Авансы → Транзакции
     - Транзакции → Авансы

#### OffsetAdvancesToTransactions() (строка 267)

Зачитывает авансы против транзакций:

```bsl
Query.Text = "SELECT ... FROM AccumulationRegister.TM1020B_AdvancesKey.Balance(
    &AdvanceBoundary,
    Company = &Company
    AND Branch = &Branch
    AND Currency = &Currency
    AND Partner = &Partner
    AND Agreement = &Agreement
    ...
)"
```

**Важно:** Фильтрация происходит по **одной валюте** (`Currency = &Currency`).

#### DistributeAdvanceToTransaction() (строка 341)

Распределяет сумму аванса по транзакциям:
- Получает балансы транзакций
- Сортирует по дате документа (`TransactionBasis.PointInTime`)
- Зачитывает последовательно от более ранних к поздним

**Условия зачета:**
1. Совпадение `Order` (если указан в авансе)
2. Совпадение `Agreement` (если указан в авансе)
3. Совпадение `Project` (с учетом `DontOffsetEmptyProjects`)

---

## Проблемные места

### 🔴 КРИТИЧЕСКАЯ ПРОБЛЕМА #1: Хранение одной валюты в T2010S_OffsetOfAdvances

**Файл:** `/IRP/src/InformationRegisters/T2010S_OffsetOfAdvances/T2010S_OffsetOfAdvances.mdo`

**Проблема:**
Регистр T2010S_OffsetOfAdvances содержит только **одно поле `Currency`** (строка 143), в то время как аванс и транзакция могут быть в **разных валютах**.

**Код записи зачета:**

`Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance()` (OffsetOfAdvancesServer.bsl:1845):
```bsl
NewRow.Currency = AdvanceRecordData.Currency;  // ⚠️ Использует валюту АВАНСА
```

`Add_T2010S_OffsetOfAdvances_FromAdvance_ToTransaction()` (OffsetOfAdvancesServer.bsl:1806):
```bsl
NewRow.Currency = TransactionRecordData.Currency;  // ⚠️ Использует валюту ТРАНЗАКЦИИ
```

**Сценарий проблемы:**
```
Аванс:       $1,000 USD
Транзакция:  €900 EUR (эквивалент $1,000 по курсу на дату)

Запись зачета будет содержать:
- Currency = USD (или EUR, в зависимости от направления)
- Amount = ???
❌ Неясно, какая сумма записана и по какому курсу пересчитана!
```

**Последствия:**
- Невозможно корректно определить курсовые разницы
- Проблемы с переоценкой валюты (ForeignCurrencyRevaluation)
- Некорректные остатки при отмене зачета

---

### 🔴 КРИТИЧЕСКАЯ ПРОБЛЕМА #2: Отсутствие TransactionCurrency в T2010S_OffsetOfAdvances

**Проблема:**
Регистры балансов (R1020B, R1021B, R2020B, R2021B) содержат **оба поля**:
- `Currency` (целевая валюта для CurrencyMovementType)
- `TransactionCurrency` (исходная валюта документа)

Но регистр зачета **T2010S_OffsetOfAdvances** содержит только `Currency`!

**Последствия:**
- Нарушена симметрия данных
- Невозможно отследить исходную валюту зачета
- Проблемы при формировании отчетов по валютам

---

### 🟠 ВЫСОКАЯ ПРОБЛЕМА #3: Недавнее исправление IRP-777/776

**Коммит:** `57d78e7` (#IRP-777 #IRP-776, дата: 2025-11-06)

**Изменения:**
```bsl
// OffsetOfAdvancesServer.bsl, строки ~1700-1800
// Добавлена обработка валют по каждой записи зачета вместо общей по документу
For Each Row_OffsetOfAdvances In Records_OffsetOfAdvances Do
    _CurrencyParameters.Insert("Currency", Row_OffsetOfAdvances.Currency);
    _CurrencyParameters.Insert("Agreement", Row_OffsetOfAdvances.Agreement);
    // ...
EndDo;
```

**Анализ:**
Команда разработки явно столкнулась с проблемами мультивалютности и пытается их решить. Однако исправление выглядит **неполным**:
- Обработка идет только для `Currency`, но не для `TransactionCurrency`
- Не решена фундаментальная проблема хранения только одной валюты

---

### 🟠 ВЫСОКАЯ ПРОБЛЕМА #4: Принудительное приравнивание валют в Aging

**Файл:** OffsetOfAdvancesServer.bsl, строки 1781-1782

```bsl
NewRow_Aging.CurrencyMovementType = ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency;
NewRow_Aging.TransactionCurrency = NewRow_Aging.Currency;  // ⚠️ Принудительное приравнивание!
```

**Проблема:**
При записи в регистр старения задолженности (Aging) система принудительно устанавливает `TransactionCurrency = Currency`. Это может быть **неверно**, если:
- Аванс был в валюте A
- Транзакция была в валюте B
- Зачет произошел с конвертацией

---

### 🟡 СРЕДНЯЯ ПРОБЛЕМА #5: Отсутствие явной конвертации валют

**Анализ кода:**
В функциях `DistributeAdvanceToTransaction()` и `OffsetTransactionsToAdvances()` **нет кода**, который бы явно обрабатывал случай:

```bsl
If AdvanceRecordData.Currency <> TransactionRecordData.Currency Then
    // ⚠️ Такого кода НЕТ!
    // Нет конвертации, нет записи курсовых разниц
EndIf;
```

**Найдено:**
Фильтрация в запросах происходит по одной валюте:
```bsl
// OffsetOfAdvancesServer.bsl:287
Query.Text = "... Currency = &Currency ..."
Query.SetParameter("Currency", AdvanceRecordData.Currency);
```

**Вопрос:**
Может ли система вообще зачитывать авансы и транзакции в разных валютах? Если да, то как?

---

### 🟡 СРЕДНЯЯ ПРОБЛЕМА #6: Переоценка валюты (ForeignCurrencyRevaluation)

**Файл:** `/IRP/src/Documents/ForeignCurrencyRevaluation/ManagerModule.bsl`

Документ переоценки валюты запрашивает регистры с условиями:
```bsl
WHERE CurrencyMovementType = SettlementCurrency
   OR Currency <> TransactionCurrency
```

**Вопрос:**
Как будет работать переоценка для записей зачета в T2010S_OffsetOfAdvances, если там:
- Только одно поле `Currency`
- Нет `TransactionCurrency`
- Неясно, по какому курсу был сделан зачет

**Риск:**
- Двойной учет курсовых разниц
- Пропуск курсовых разниц
- Некорректная сумма переоценки

---

### 🟡 СРЕДНЯЯ ПРОБЛЕМА #7: DELETE-поля в T2010S_OffsetOfAdvances

**Файл:** T2010S_OffsetOfAdvances.mdo

Регистр содержит множество полей с префиксом `DELETE_`:
- `DELETE_TransactionAgreement` (строка 232)
- `DELETE_AdvanceAgreement` (строка 248)
- `DELETE_FromAdvanceKey` (строка 298)
- `DELETE_ToTransactionKey` (строка 315)
- и др.

**Анализ:**
Это признак рефакторинга структуры данных. Возможно, ранее система работала иначе, и остались legacy-поля.

**Риск:**
- Неполная миграция данных
- Код может все еще использовать устаревшие поля
- Несогласованность данных в старых и новых записях

---

### 🔵 НИЗКАЯ ПРОБЛЕМА #8: Сложность отладки

**Проблема:**
Модуль OffsetOfAdvancesServer.bsl имеет размер **более 2500 строк** со сложной вложенной логикой:
- Множественные циклы
- Рекурсивные вызовы
- Условная логика в зависимости от типа документа

**Последствия:**
- Трудно отследить путь выполнения
- Высокая вероятность edge-cases
- Сложность тестирования

---

## Рекомендации

### ✅ ВЫСОКИЙ ПРИОРИТЕТ

#### 1. Добавить поле TransactionCurrency в T2010S_OffsetOfAdvances

**Действия:**
```xml
<!-- T2010S_OffsetOfAdvances.mdo -->
<dimensions>
  <!-- Существующее поле -->
  <dimension name="Currency">
    <type>CatalogRef.Currencies</type>
  </dimension>

  <!-- ДОБАВИТЬ -->
  <dimension name="TransactionCurrency">
    <synonym>Transaction currency</synonym>
    <type>CatalogRef.Currencies</type>
  </dimension>
</dimensions>
```

**Изменить код:**
```bsl
// OffsetOfAdvancesServer.bsl
Function Add_T2010S_OffsetOfAdvances_FromAdvance_ToTransaction(...)
    NewRow.Currency = TransactionRecordData.Currency;
    NewRow.TransactionCurrency = AdvanceRecordData.Currency;  // ДОБАВИТЬ
    // ...
EndFunction

Function Add_T2010S_OffsetOfAdvances_FromTransaction_ToAdvance(...)
    NewRow.Currency = AdvanceRecordData.Currency;
    NewRow.TransactionCurrency = TransactionRecordData.Currency;  // ДОБАВИТЬ
    // ...
EndFunction
```

---

#### 2. Реализовать явную конвертацию валют при зачете

**Добавить функцию:**
```bsl
Function ConvertCurrencyAmount(SourceAmount, SourceCurrency, TargetCurrency, ConversionDate) Export
    If SourceCurrency = TargetCurrency Then
        Return SourceAmount;
    EndIf;

    Rate_Source = GetCurrencyRate(SourceCurrency, ConversionDate);
    Rate_Target = GetCurrencyRate(TargetCurrency, ConversionDate);

    AmountInBaseCurrency = SourceAmount * Rate_Source;
    TargetAmount = AmountInBaseCurrency / Rate_Target;

    Return TargetAmount;
EndFunction
```

**Использовать в зачете:**
```bsl
Procedure DistributeAdvanceToTransaction(...)
    // ...
    If AdvanceRecordData.Currency <> TransactionRecordData.Currency Then
        CanWriteoff_InTransactionCurrency = ConvertCurrencyAmount(
            CanWriteoff,
            AdvanceRecordData.Currency,
            TransactionRecordData.Currency,
            Document.Date
        );

        ExchangeDifference = CanWriteoff_InTransactionCurrency - CanWriteoff;
        If ExchangeDifference <> 0 Then
            // Записать курсовую разницу
            PostExchangeDifference(ExchangeDifference, ...);
        EndIf;
    EndIf;
    // ...
EndProcedure
```

---

#### 3. Добавить регистр для курсовых разниц при зачете

**Создать новый регистр:**
```
T2016S_OffsetExchangeDifferences
├── Dimensions
│   ├── Company
│   ├── Branch
│   ├── Partner
│   ├── LegalName
│   ├── OffsetDocument       (ссылка на VendorsAdvancesClosing/CustomersAdvancesClosing)
│   ├── AdvanceCurrency
│   ├── TransactionCurrency
├── Resources
│   ├── ExchangeDifference  (сумма курсовой разницы)
│   ├── AdvanceAmount       (сумма в валюте аванса)
│   ├── TransactionAmount   (сумма в валюте транзакции)
```

**Цель:**
Явное хранение информации о курсовых разницах, возникших при зачете.

---

### ✅ СРЕДНИЙ ПРИОРИТЕТ

#### 4. Завершить исправление IRP-777/776

**Проверить:**
- Все ли случаи обработаны в новой логике?
- Работает ли переоценка валюты с новым кодом?
- Нет ли регрессии для документов в одной валюте?

**Добавить тесты:**
```gherkin
Scenario: Зачет аванса в USD против транзакции в EUR
    Given Аванс $1,000 USD по курсу 1.1 к EUR
    And Транзакция €900 EUR
    When Выполнен зачет авансов
    Then Остаток аванса = $0
    And Остаток транзакции = €0
    And Курсовая разница = $100 (или эквивалент в базовой валюте)
```

---

#### 5. Рефакторинг модуля OffsetOfAdvancesServer

**Разделить на подмодули:**
```
OffsetOfAdvancesServer (главный)
├── OffsetOfAdvancesCore      (ядро логики)
├── OffsetOfAdvancesCurrency  (валютные операции)
├── OffsetOfAdvancesAging     (старение задолженности)
└── OffsetOfAdvancesQueries   (запросы к регистрам)
```

**Цели:**
- Улучшить читаемость
- Упростить тестирование
- Снизить вероятность ошибок

---

#### 6. Убрать DELETE-поля

**Действия:**
1. Убедиться, что никакой код не использует DELETE-поля
2. Создать скрипт миграции данных
3. Удалить поля из структуры регистра

**Риски:**
Возможны проблемы с синхронизацией (ExchangePlan) и внешними интеграциями.

---

### ✅ НИЗКИЙ ПРИОРИТЕТ

#### 7. Добавить логирование операций зачета

**Цель:**
Отладка проблем в продакшене, аудит операций.

**Структура лога:**
```
OffsetLog
├── Timestamp
├── User
├── OffsetDocument
├── AdvanceDocument
├── TransactionDocument
├── AdvanceCurrency
├── TransactionCurrency
├── AdvanceAmount
├── TransactionAmount
├── ExchangeRate
├── ExchangeDifference
```

---

#### 8. Создать отчет по мультивалютным зачетам

**Название:** "Анализ зачетов в разных валютах"

**Поля:**
- Период
- Партнер
- Валюта аванса
- Валюта транзакции
- Сумма зачета в валюте аванса
- Сумма зачета в валюте транзакции
- Курсовая разница
- Статус (OK / Ошибка)

---

## Анализ недавних изменений

### Commit 57d78e7: #IRP-777 #IRP-776

**Дата:** 2025-11-06

**Суть изменений:**
Переход от обработки валют на уровне документа к обработке на уровне каждой записи зачета.

**До:**
```bsl
_CurrencyParameters.Insert("Currency", Parameters.Object.Currency);  // Общая валюта документа
UpdateCurrencyTable(_CurrencyParameters, CurrencyTable);
```

**После:**
```bsl
For Each Row_OffsetOfAdvances In Records_OffsetOfAdvances Do
    _CurrencyParameters.Insert("Currency", Row_OffsetOfAdvances.Currency);  // Валюта каждой записи
    _CurrencyParameters.Insert("Agreement", Row_OffsetOfAdvances.Agreement);
    UpdateCurrencyTable(_CurrencyParameters, CurrencyTable_Agreement);
EndDo;
```

**Оценка:**
Это **правильное направление**, но изменение выглядит **неполным**. Не решены проблемы:
- Отсутствие TransactionCurrency
- Отсутствие конвертации валют
- Отсутствие учета курсовых разниц

---

## Выводы

### Текущее состояние системы

#### ✅ Что работает хорошо:

1. **Разделение регистров**
   - Четкое разграничение авансов и транзакций
   - Отдельные регистры для Vendors и Customers

2. **Концепция CurrencyMovementType**
   - Гибкая система учета в разных валютах
   - Поддержка произвольных типов валютных движений

3. **Зачет по времени**
   - Логичная последовательность зачета по PointInTime
   - Учет порядка и проектов при зачете

4. **Активное развитие**
   - Команда работает над улучшением мультивалютности
   - Недавние исправления (IRP-777/776)

---

#### ❌ Что требует исправления:

1. **Хранение валют в T2010S_OffsetOfAdvances**
   - ⚠️ КРИТИЧНО: Только одно поле Currency
   - Невозможно корректно обработать зачеты в разных валютах

2. **Отсутствие конвертации валют**
   - Нет явной логики конвертации при зачете
   - Нет учета курсовых разниц

3. **Принудительное приравнивание валют**
   - В Aging: `TransactionCurrency = Currency`
   - Может привести к некорректным данным

4. **Сложность кода**
   - Модуль > 2500 строк
   - Трудно поддерживать и тестировать

---

### Риски для бизнеса

#### 🔴 ВЫСОКИЙ РИСК:

- **Некорректный учет валютной позиции**
  Если компания работает с несколькими валютами, остатки по партнерам могут быть неточными.

- **Проблемы при переоценке валюты**
  Документ ForeignCurrencyRevaluation может рассчитать неверные курсовые разницы.

#### 🟠 СРЕДНИЙ РИСК:

- **Ошибки при отмене зачета**
  При отмене документа зачета возможны расхождения.

- **Сложность аудита**
  Невозможно отследить, по какому курсу был сделан зачет.

---

### План действий

#### Этап 1: Срочные исправления (1-2 недели)

1. ✅ Добавить поле `TransactionCurrency` в T2010S_OffsetOfAdvances
2. ✅ Модифицировать функции записи зачета для хранения обеих валют
3. ✅ Создать миграцию для существующих данных (заполнить TransactionCurrency = Currency)

#### Этап 2: Функциональные улучшения (1 месяц)

4. ✅ Реализовать функцию конвертации валют `ConvertCurrencyAmount()`
5. ✅ Добавить проверку валют в процедурах зачета
6. ✅ Создать регистр курсовых разниц при зачете (T2016S_OffsetExchangeDifferences)
7. ✅ Добавить постинг курсовых разниц в бухгалтерию

#### Этап 3: Рефакторинг (2 месяца)

8. ✅ Разделить OffsetOfAdvancesServer на подмодули
9. ✅ Создать unit-тесты для мультивалютных зачетов
10. ✅ Убрать DELETE-поля из T2010S_OffsetOfAdvances
11. ✅ Оптимизировать запросы к регистрам

#### Этап 4: Мониторинг и отчетность (ongoing)

12. ✅ Добавить логирование операций зачета
13. ✅ Создать отчет по мультивалютным зачетам
14. ✅ Настроить алерты на аномалии в валютных операциях

---

## Приложения

### A. Список ключевых файлов

| Путь | Описание |
|------|----------|
| `/IRP/src/AccumulationRegisters/R1020B_AdvancesToVendors/` | Регистр авансов поставщикам |
| `/IRP/src/AccumulationRegisters/R1021B_VendorsTransactions/` | Регистр транзакций поставщиков |
| `/IRP/src/AccumulationRegisters/R2020B_AdvancesFromCustomers/` | Регистр авансов от клиентов |
| `/IRP/src/AccumulationRegisters/R2021B_CustomersTransactions/` | Регистр транзакций клиентов |
| `/IRP/src/InformationRegisters/T2010S_OffsetOfAdvances/` | Регистр зачета авансов |
| `/IRP/src/CommonModules/CurrenciesServer/Module.bsl` | Модуль работы с валютами |
| `/IRP/src/CommonModules/OffsetOfAdvancesServer/Module.bsl` | Модуль зачета авансов |
| `/IRP/src/Documents/VendorsAdvancesClosing/` | Документ зачета авансов поставщикам |
| `/IRP/src/Documents/CustomersAdvancesClosing/` | Документ зачета авансов клиентам |
| `/IRP/src/Documents/ForeignCurrencyRevaluation/` | Документ переоценки валюты |

---

### B. Глоссарий

| Термин | Описание |
|--------|----------|
| **PartnerBalance** | Общее название для регистров взаиморасчетов с партнерами |
| **CurrencyMovementType** | Тип валютного движения (SettlementCurrency, LegalCurrency, etc.) |
| **AdvancesClosing** | Документ зачета авансов против задолженности |
| **Offset** | Зачет (процесс сопоставления аванса и транзакции) |
| **Aging** | Старение задолженности (классификация по срокам) |
| **TransactionBasis** | Документ-основание транзакции (Invoice, Return, etc.) |
| **SettlementCurrency** | Валюта расчетов (Currency в документе) |
| **LegalCurrency** | Валюта юридического лица |
| **ExchangeDifference** | Курсовая разница |

---

### C. SQL-запросы для проверки данных

#### Проверка зачетов в разных валютах

```sql
-- Найти зачеты, где валюта аванса != валюте транзакции
-- (после добавления поля TransactionCurrency)

SELECT
    T2010S.Document,
    T2010S.Partner,
    T2010S.Currency AS OffsetCurrency,
    T2010S.TransactionCurrency,
    T2010S.Amount,
    T2010S.AdvanceOrder,
    T2010S.TransactionDocument
FROM
    InformationRegister.T2010S_OffsetOfAdvances AS T2010S
WHERE
    T2010S.Currency <> T2010S.TransactionCurrency
ORDER BY
    T2010S.Period DESC
```

#### Проверка остатков по валютам

```sql
-- Остатки авансов по валютам
SELECT
    Adv.Partner,
    Adv.Currency,
    SUM(Adv.Amount) AS AdvanceBalance
FROM
    AccumulationRegister.R1020B_AdvancesToVendors.Balance() AS Adv
WHERE
    Adv.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
GROUP BY
    Adv.Partner,
    Adv.Currency
HAVING
    SUM(Adv.Amount) <> 0
```

---

**Конец отчета**
