// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.ui.datepicker
//= require jquery-tablesorter
//= require jquery-tablesorter/jquery.metadata
//= require jquery-tablesorter/jquery.tablesorter
//= require jquery-tablesorter/jquery.tablesorter.widgets
//= require jquery-tablesorter/addons/pager/jquery.tablesorter.pager
//= require bootstrap
//= require ckeditor/init
//= require_tree .

$(document).ready(function(){	
  $('.datePicker').datepicker();
	
	
  $("#users-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-users-table"), size: 50})
  ;
  $("#users-admin-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-users-admin-table"), size: 50})
  ;
  $("#users-staff-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-users-staff-table"), size: 50})
  ;
  $("#users-authors-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-users-authors-table"), size: 50})
  ;
  $("#users-unassociated-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-users-unassociated-table"), size: 50})
  ;
  $("#unaffiliated-users-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-unaffiliated-users-table"), size: 50})
  ;
  $("#superadmin-users-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-superadmin-users-table"), size: 50})
  ;
  $("#publishers-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-publishers-table"), size: 50})
  ;
  $("#libraries-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-libraries-table"), size: 50})
  ;
  $("#authors-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-authors-table"), size: 50})
  ;
  $("#form_items-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-form_items-table"), size: 50})
  ;
  $("#form_items_ours-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-form_items_ours-table"), size: 50})
  ;
  $("#groups_ours-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-groups_ours-table"), size: 50})
  ;
  $("#questionnaires-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-questionnaires-table"), size: 50})
  ;
  $("#responses-table")
  	.tablesorter({sortList: [[0,0]]})
    .tablesorterPager({container: $("#pager-responses-table"), size: 50})
  ;
  
  $('#pub_affiliation_dropdown').hide();
  $('#lib_affiliation_dropdown').hide();
  
});

jQuery(function(){

  $('#affiliation_Publisher').change(function() {
	$('#pub_affiliation_dropdown').show();
	$('#lib_affiliation_dropdown').hide();
   });
   
  $('#affiliation_Library').change(function() {
 	$('#pub_affiliation_dropdown').hide();
 	$('#lib_affiliation_dropdown').show();
    }); 
});
