jQuery(function($) {
  $('#payment-form').submit(function(event) {
    var $form = $(this);
    $form.find('#payment-submit').prop('disabled', true);
    Stripe.card.createToken($form, stripeResponseHandler);
    // Prevent the form from submitting with the default action
    return false;
  });

  var stripeResponseHandler = function(status, response) {
    var $form = $('#payment-form');
      if (response.error) {
        $form.find('#payment-errors').text(response.error.message);
        $form.find('#payment-submit').prop('disabled', false);
      } else {
        var token = response.id;
        $form.append($('<input type="hidden" name="stripeToken" />').val(token));
        $form.get(0).submit();
    }
  };
});
