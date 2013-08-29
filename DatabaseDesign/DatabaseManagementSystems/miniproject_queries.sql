SELECT * FROM webshopsales WHERE customer IN (SELECT cid FROM customer WHERE authentication=@authentication);
SELECT * FROM webshopsales INNER JOIN customer ON webshopsales.customer=customer.cid WHERE authentication=@authentication;
// Which is better??