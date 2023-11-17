/**
 * Marking class for widgets (usually forms) passed as child to CustomSigninWidget.
 * Contains callback to transfer control from child to parent container
 */
abstract class IForm {
  void setListener(Function(String, String) callback);
}