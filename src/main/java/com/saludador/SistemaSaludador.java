package com.saludador;

import java.time.LocalTime;
import javafx.application.Application;
import javafx.geometry.Insets;
import javafx.scene.Scene;
import javafx.scene.control.*;
import javafx.scene.layout.*;
import javafx.stage.Stage;

public class SistemaSaludador extends Application {
    @Override
    public void start(Stage stage) {
        Label titulo = new Label("Sistema Saludador");
        titulo.setStyle("-fx-font-size: 26px; -fx-font-weight: bold;");
        Button solicitar = new Button("Solicitar saludo");
        TextField nombre = new TextField();
        nombre.setPromptText("Tu nombre");
        TextField edad = new TextField();
        edad.setPromptText("Edad en años");
        LocalTime ahora = LocalTime.now();
        ComboBox<Integer> hora = new ComboBox<>();
        ComboBox<Integer> minutos = new ComboBox<>();
        for (int i = 1; i <= 12; i++) hora.getItems().add(i);
        for (int i = 0; i < 60; i++) minutos.getItems().add(i);
        hora.setValue(ahora.getHour() % 12 == 0 ? 12 : ahora.getHour() % 12);
        minutos.setValue(ahora.getMinute());
        ComboBox<String> periodo = new ComboBox<>();
        periodo.getItems().addAll("AM", "PM");
        periodo.setValue(ahora.getHour() < 12 ? "AM" : "PM");
        HBox horario = new HBox(8, hora, new Label(":"), minutos, periodo);
        GridPane campos = new GridPane();
        campos.setHgap(16);
        campos.setVgap(14);
        campos.addRow(0, new Label("Nombre"), nombre);
        campos.addRow(1, new Label("Edad"), edad);
        campos.addRow(2, new Label("Hora"), horario);
        Label error = new Label();
        error.setStyle("-fx-text-fill: #b42318;");
        error.setWrapText(true);
        Label resultado = new Label();
        resultado.setStyle("-fx-font-size: 18px; -fx-text-fill: #166534;");
        resultado.setWrapText(true);
        Button aceptar = new Button("Aceptar");
        aceptar.setDefaultButton(true);
        VBox formulario = new VBox(16, campos, aceptar, error, resultado);
        formulario.setVisible(false);
        formulario.setManaged(false);
        solicitar.setOnAction(event -> {
            formulario.setManaged(true);
            formulario.setVisible(true);
            nombre.requestFocus();
        });
        aceptar.setOnAction(event -> {
            resultado.setText("");
            String nombreIngresado = nombre.getText().strip();
            if (nombreIngresado.isEmpty()) {
                error.setText("Ingresa tu nombre.");
                nombre.requestFocus();
                return;
            }
            int edadIngresada;
            try {
                edadIngresada = Integer.parseInt(edad.getText().strip());
                if (edadIngresada < 0 || edadIngresada > 120) throw new NumberFormatException();
            } catch (NumberFormatException exception) {
                error.setText("Ingresa una edad entera entre 0 y 120.");
                edad.requestFocus();
                return;
            }
            error.setText("");
            int hora24 = hora.getValue() % 12 + ("PM".equals(periodo.getValue()) ? 12 : 0);
            String saludo = hora24 >= 6 && hora24 < 12 ? "Buenos días"
                    : hora24 >= 12 && hora24 < 18 ? "Buenas tardes" : "Buenas noches";
            resultado.setText("¡" + saludo + ", " + nombreIngresado + "! Tienes "
                    + edadIngresada + (edadIngresada == 1 ? " año." : " años."));
        });
        VBox contenido = new VBox(24, titulo, solicitar, formulario);
        contenido.setPadding(new Insets(32));
        contenido.setStyle("-fx-font-family: 'Segoe UI'; -fx-font-size: 14px; -fx-background-color: #f7f9fc;");
        stage.setTitle("Sistema Saludador");
        stage.setScene(new Scene(contenido, 570, 490));
        stage.setMinWidth(540);
        stage.setMinHeight(480);
        stage.show();
    }

    public static void main(String[] args) {
        launch(args);
    }
}
