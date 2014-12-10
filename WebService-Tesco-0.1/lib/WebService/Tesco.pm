package WebService::Tesco;

use strict;
use warnings;


my $LOGIN="https://secure.techfortesco.com/tescolabsapi/restservice.aspx?command=LOGIN&email=&password=";
my $SEARCH="https://secure.techfortesco.com/tescolabsapi/restservice.aspx?command=PRODUCTSEARCH";


use Data::Dumper;
use LWP::Simple;
use JSON;
use URI::Escape;
use Encode;

=head1 NAME

WebService::Tesco

=head1 VERSION 

0.1

Simple wrapper for the Tesco API documented here:

http://www.tescolabs.com/?p=7171

=cut 

=head1 methods

=over

=item new


Parameters:
      my $tesco = WebService::Tesco->new({
             dev_key => $dev_key,
             app_key => $app_key,
          });

=cut

sub new {
    my ($class, $params) = @_ ;
    my $obj = bless {}, $class ;
    $obj->{cfg} = $params;
    $obj->{session} = $obj->auth($obj->{cfg});
    return $obj ;
}

=item auth

Called from new. You don't need this.

=cut

sub auth {
  my ($self, $params) = @_;

  my $str = $LOGIN . 
    "&developerkey=" . $self->{cfg}->{dev_key} .
    "&applicationkey=" . $self->{cfg}->{app_key} ;

  warn $str;
  my $ret = get($str);

  $ret = decode_json $ret;
  warn  $ret->{SessionKey};
  $self->{session} = $ret->{SessionKey};
  return $ret->{SessionKey} ;
}

=item search

Parameters:
     my $res = $tesco->search({
            searchtext => "Chef",
            page       => 1         # defaults to 1
          });

     $res is an array of hashrefs:

     {
       "StatusCode": 0,
       "StatusInfo": "Command Processed OK",
       "PageNumber": 1,
       "TotalPageCount": 1,
       "TotalProductCount": 1,
       "PageProductCount": 1,
       "Products":
          [
              {
                "BaseProductId": "77534748",
                "EANBarcode": "5055761903331",
                "CheaperAlternativeProductId": "",
                "HealthierAlternativeProductId": "",
                "ImagePath": "http://img.tesco.com/Groceries/pi/331/5055761903331/IDShot_90x90.jpg",
                "MaximumPurchaseQuantity": 99,
                "Name": "Chef Dvd",
                "OfferPromotion": "",
                "OfferValidity": "",
                "OfferLabelImagePath": "",
                "ShelfCategory": "",
                "ShelfCategoryName": "",
                "Price": 10,
                "PriceDescription": "10.00 each",
                "ProductId": "285334791",
                "ProductType": "QuantityOnlyProduct",
                "UnitPrice": 10,
                "UnitType": "EACH"
              }
           ]
     }

=cut

=back

sub search {
  my ($self, $params) = @_ ;

  warn Dumper($params) ;

  my $str = $SEARCH . 
                    "&sessionkey=" . $self->{session} .
                    "&page=" . $params->{page}  .
                    "&searchtext=" . uri_escape("chef dvd");
  warn $str;

  my $ret = get($str) ;
  $ret = decode_json(encode_utf8($ret)) ;
  warn Dumper($ret);

  return $ret;
}



1;
