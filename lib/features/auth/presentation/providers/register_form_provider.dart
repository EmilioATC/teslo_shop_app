import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop_app/features/shared/shared.dart';

//! 3 - StateNotifierProvider - consume afuera
final registerFormProvider = StateNotifierProvider.autoDispose<RegisterFormNotifier,RegisterFormState>((ref) {




  return RegisterFormNotifier(
  );
});


//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {

  RegisterFormNotifier(): super( RegisterFormState() );
  
  onEmailChanged( String value ) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([ newEmail, state.password, state.name, state.spassword  ])
    );
  }

  onPasswordChanged( String value ) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([ newPassword, state.email, state.name, state.spassword  ])
    );
  }
  onSPasswordChanged( String value ) {
    final newSPassword = Password.dirty(value);
    state = state.copyWith(
      spassword: newSPassword,
      isValid: Formz.validate([ newSPassword, state.email, state.name, state.password  ])
    );
  }

  onNameChanged( String value ) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate([ newName, state.email, state.password, state.spassword  ])
    );
  }

  onFormSubmit() async {
    _touchEveryField();

    if ( !state.isValid ) return;

    

  }

  _touchEveryField() {

    final email    = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final spassword = Password.dirty(state.spassword.value);
    final name = Name.dirty(state.name.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      name: name,
      spassword: spassword,
      isValid: Formz.validate([ email, password, name, spassword ])
    );

  }

}


//! 1 - State del provider
class RegisterFormState {

  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final Password spassword;
  final Name name;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.name = const Name.pure(),
    this.spassword = const Password.pure()
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Name? name,
    Password? password,
    Password? spassword,
  }) => RegisterFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
    spassword: spassword ?? this.spassword,
    name: name ?? this.name,
  );

  @override
  String toString() {
    return '''
  LoginFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    spassword: $spassword
    name: $name
''';
  }
}