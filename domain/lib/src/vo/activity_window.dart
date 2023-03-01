import '../ar/account.dart';
import '../ar/activity.dart';
import 'money.dart';

class ActivityWindow {
  List<Activity> activities;

  ActivityWindow(this.activities);

  DateTime getStartTimestamp() {
    return activities.map((e) => e.timestamp).reduce(
        (value, element) => value.compareTo(element) < 0 ? value : element);
  }

  DateTime getEndTimestamp() {
    return activities.map((e) => e.timestamp).reduce(
        (value, element) => value.compareTo(element) > 0 ? value : element);
  }

  Money calculateBalance(AccountId accountId) {
    var depositBalance = activities
        .where((element) => element.targetAccountId == accountId)
        .map((e) => e.money)
        .fold(Money.ZERO,
            (previousValue, element) => Money.add(previousValue, element));
    var withdrawalBalance = activities
        .where((element) => element.sourceAccountId == accountId)
        .map((e) => e.money)
        .fold(Money.ZERO,
            (previousValue, element) => Money.add(previousValue, element));
    return Money.add(depositBalance, withdrawalBalance.negate());
  }

  addActivity(Activity activity) {
    activities.add(activity);
  }
}
