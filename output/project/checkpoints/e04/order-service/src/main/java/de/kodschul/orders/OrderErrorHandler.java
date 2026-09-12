package de.kodschul.orders;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class OrderErrorHandler {
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleInvalidOrder() {
        ErrorResponse error = new ErrorResponse("INVALID_ORDER", "Order data is invalid");
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }
}