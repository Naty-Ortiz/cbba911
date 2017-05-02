// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.

//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require google_maps_custom

//= require bootstrap
//= require bootstrap3-typeahead.min
//= require bootstrap3-autocomplete-input.min
//= require gmaps/google
//= require underscore
//= require markerclusterer

//= require autocomplete-rails
//= require selectivity
//= require awesomplete
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap-timepicker
//= require bootstrap-typeahead-rails


//= require fusioncharts/fusioncharts
//= require fusioncharts/fusioncharts.charts
//= require fusioncharts/themes/fusioncharts.theme.fint


//= require toastr
//= require turbolinks
//= require Chart.bundle
//= require chartkick
//= require_tree .

$(function () {
    if ($("#complains").length>0){
        setTimeout(updateComplains, 10000);
    }
});
function updateComplains(){
    $.getScript("/complains.js")
    setTimeout(updateComplains,10000);
}



if ('serviceWorker' in navigator) {
  console.log('Service Worker is supported');
  navigator.serviceWorker.register('/serviceworker.js')
    .then(function(registration) {
      console.log('Successfully registered!', ':^)', registration);
      registration.pushManager.subscribe({ userVisibleOnly: true })
        .then(function(subscription) {
            console.log('endpoint:', subscription.endpoint);
        });
  }).catch(function(error) {
    console.log('Registration failed', ':^(', error);
  });
}
$(function(){
    if ($("#complains").length > 0){
        setTimeout(updateComplains,10000);

    }
});
function updateComplains(){
    $.getScript("/complains.js");
    setTimeout(updateComplains,10000);
}

    $(document).ready(function() {


     toastr.options = {
                      "closeButton": false,
                      "debug": false,
                      "positionClass": "toast-bottom-right",
                      "onclick": null,
                      "showDuration": "300",
                      "hideDuration": "1000",
                      "timeOut": "5000",
                      "extendedTimeOut": "1000",
                      "showEasing": "swing",
                      "hideEasing": "linear",
                      "showMethod": "fadeIn",
                      "hideMethod": "fadeOut"
                  };

    });
var ready = function(){

    $('#verification_list_list_category_id').change( function(){
        $('#list-title').text("Registrando lista de " + $('#verification_list_list_category_id  option:selected').text());
    });

    $('#loginButton').on('click', function(event) {
        var login = $('#login')[0].value;
        var password = $('#password')[0].value;
        var errorBox = $('#error-box');
        errorBox.text('');
        if (login.length === 0 && password.length === 0) {
            event.preventDefault();
            errorBox.text('Debe introducir su contrasena y su nombre de ususario.');
        }
        else if (login.length === 0){
            event.preventDefault();
            errorBox.text('Debe introducir su nombre de ususario.');
        }
        else if(password.length === 0){
            event.preventDefault();
            errorBox.text('Debe introducir su contrasena.');
        }
    });

    $('#reception-submit-button').on('click', function(event) {
        var descriptionFields = $('.verified-field-text');
        if (descriptionFields.length!==0){
            for(var i = 0; i < descriptionFields.length; i++){
                if (descriptionFields[i].value === ""){
                    event.preventDefault();
                    $('#documents-reception-error-panel').css({ display:'block' });
                }
            }
            //documents-reception-error-panel (clase del panel)
        }
    });

    $('#crearLista').on('click', function(event){
        var descriptions = $('.verificationField'), errorPanel = $('#error-panel'), message = $('#error-panel-message');
        var band = true;
        errorPanel.css({display: 'none'});
        if(descriptions.length === 0){
            event.preventDefault();
            errorPanel.css({display: 'block'});
            message.text('Debe existir por lo menos un campo en la lista.');
        }
        else{
            for(var i = 0; i < descriptions.length; i++){
                if($("#verification_list_verification_fields_attributes_"+i+"_description").val() !== ''){
                    band = false;
                    break;
                }
            }
            if(band){
                event.preventDefault();
                errorPanel.css({display: 'block'});
                message.text('Debe llenar por lo menos un campo de verificacion.');
            }

        }
    });

    stabilize();
};

$(document).ready(ready);
$(document).on('page:load', ready);
//$(document).ajaxStart(function() { Pace.restart(); });

var count = 0;

function checkCount(){
    count = parseInt($('#count').text());
    if(isNaN(count)){
        if($('.verificationField').length !== 0)
            count = $('.verificationField').length;
        else
            count = 0;

        $('#count').text(count);
    }
}

function stabilize(){
    var sidebar = $('#main-sidebar');
    while(sidebar.height() + 110 < $(document).height() && sidebar.height() !== null){
        sidebar.append('<br>').append('<br>').append('<br>').append('<br>');
    }
    $(window).trigger('resize');
}

//function changeList(){
//    $('#list-title').text("Registrando lista de " + $('#verification_list_list_category_id  option:selected').text());
//}

function loadCountries(){
    setTimeout(function(){
        var countrySelect = $('#person_country');
        countrySelect.addClass('form-control');
        countrySelect.change(function(event) {
            var country_code, select_wrapper, url;
            select_wrapper = $('#order_state_code_wrapper');
            $('select', select_wrapper).attr('disabled', true);
            country_code = $(this).val();
            url = "/orders/subregion_options?parent_region=" + country_code;
            return select_wrapper.load(url);
        });
        countrySelect.trigger('change');
    }, 10);
}


var addField = function(){
    checkCount();
    var descripField = '<div class="row" > <label for="verification_list_verification_fields_attributes_'+count+'_descripcion">Criterio de Verificacion</label><br> <textarea class="form-control tiny-text-area verificationField" name="verification_list[verification_fields_attributes]['+count+'][description]" id="verification_list_verification_fields_attributes_'+count+'_description"></textarea></div>';
    $('#fields').append(descripField);
    count++;
    $('#count').text(count);
};
$("form").on("keypress", function (e) {
    if (e.keyCode == 13) {
        return false;
    }
});
$('#complain_form').on('keyup keypress', function(e) {
  var keyCode = e.keyCode || e.which;
  if (keyCode === 13) {
    e.preventDefault();
    return false;
  }
});


//= require serviceworker-companion
