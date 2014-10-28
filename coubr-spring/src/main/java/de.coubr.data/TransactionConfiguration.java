package com.coubr.data;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.TransactionManagementConfigurer;

import javax.persistence.EntityManagerFactory;

/**
 * Created by sebastian on 05.10.14.
 */
@Configuration
@EnableTransactionManagement()
public class TransactionConfiguration implements TransactionManagementConfigurer {

    @Autowired
    EntityManagerFactory emf;

    @Bean
    public PlatformTransactionManager transactionManager() {
        return new JpaTransactionManager(emf);
    }

    @Override
    public PlatformTransactionManager annotationDrivenTransactionManager() {
        return transactionManager();
    }
}
