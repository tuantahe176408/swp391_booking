package com.project.dao;

import com.project.model.Voucher;
import java.util.List;
import java.util.Optional;

/**
 * Data Access Object Interface: Voucher Operations
 * Package: com.project.dao
 */
public interface VoucherDAO {
    Optional<Voucher> findByCode(String code);
    List<Voucher> getAllVouchers();
    int insertVoucher(Voucher voucher);
    boolean updateVoucher(Voucher voucher);
    boolean toggleActive(int voucherId, boolean active);
    boolean deleteVoucher(int voucherId);
    boolean incrementUsedCount(int voucherId);
}
