package com.coubr.web.services;

import com.coubr.web.json.localbusiness.LocalBusiness;
import com.coubr.web.json.localbusiness.LocalBusinessDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by sebastian on 05.10.14.
 */
@Service(value = "storeService")
@Transactional
public class LocalBusinessService {

    public List<LocalBusiness> getStores(String email) {

        return null;
    }

    public List<LocalBusinessDetails> getStoresWithDetails(String email) {


        return null;
    }

    public LocalBusinessDetails getStore(String email, String storeId) {


        return null;
    }


}
